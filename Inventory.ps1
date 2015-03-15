##############################################################################
##
## Inventory
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Serves as the configuration script for a custom remoting endpoint that
exposes only the Get-Inventory custom command.

.EXAMPLE

PS >Register-PsSessionConfiguration Inventory `
    -StartupScript 'C:\Program Files\Endpoints\Inventory.ps1'
PS >Enter-PsSession leeholmes1c23 -ConfigurationName Inventory

[leeholmes1c23]: [Inventory] > Get-Command

CommandType     Name                          Definition
-----------     ----                          ----------
Function        Exit-PSSession                [CmdletBinding()]...
Function        Get-Command                   [CmdletBinding()]...
Function        Get-FormatData                [CmdletBinding()]...
Function        Get-Help                      [CmdletBinding()]...
Function        Get-Inventory                 ...
Function        Measure-Object                [CmdletBinding()]...
Function        Out-Default                   [CmdletBinding()]...
Function        prompt                        ...
Function        Select-Object                 [CmdletBinding()]...

[leeholmes1c23]: [Inventory] > Get-Inventory

SystemDirectory : C:\Windows\system32
Organization    :
BuildNumber     : 6002
RegisteredUser  : Lee Holmes
SerialNumber    : 89580-433-1295803-71477
Version         : 6.0.6002

[leeholmes1c23]: [Inventory] > 1+1
The syntax is not supported by this runspace. This might be because it is
in no-language mode.
    + CategoryInfo          :
    + FullyQualifiedErrorId : ScriptsNotAllowed

[leeholmes1c23]: [Inventory] > Exit-PsSession
PS >

#>

Set-StrictMode -Off

## Create a new function to get inventory
function Get-Inventory
{
    Get-WmiObject Win32_OperatingSystem
}

## Customize the prompt
function Prompt
{
    "[Inventory] > "
}

## Remember which functions we want to expose to the user
$exportedCommands = "Get-Inventory","Prompt"

## The System.Management.Automation.Runspaces.InitialSessionState class
## has a CreateRestricted() method that creates a default locked-down
## secure configuration for a remote session. This configuration only
## supports the bare minimum required for interactive remoting.
$issType = [System.Management.Automation.Runspaces.InitialSessionState]
$iss = $issType::CreateRestricted("RemoteServer")

## Add the commands to a hashtable so that we can access them easily
$issHashtable = @{}
foreach($command in $iss.Commands)
{
    $issHashtable[$command.Name + "-" + $command.CommandType] = $command
}

## Go through all of functions built into the restricted runspace and add
## them to this session. These are proxy functions to limit the functionality
## of commands that we need (such as Get-Command, Select-Object, etc.)
foreach($function in $iss.Commands |
    Where-Object { $_.CommandType -eq "Function" })
{
    Set-Content "function:\$($function.Name)" -Value $function.Definition
}

## Go through all of the commands in this session
foreach($command in Get-Command)
{
    ## If it was one of our exported commands, keep it Public
    if($exportedCommands -contains $command.Name) { continue }

    ## If the current command is defined as Private in the initial session
    ## state, mark it as private here as well.
    $issCommand = $issHashtable[$command.Name + "-" + $command.CommandType]
    if((-not $issCommand) -or ($issCommand.Visibility -ne "Public"))
    {
        $command.Visibility = "Private"
    }
}

## Finally, prevent all access to the PowerShell language
$executionContext.SessionState.Scripts.Clear()
$executionContext.SessionState.Applications.Clear()
$executionContext.SessionState.LanguageMode = "NoLanguage"