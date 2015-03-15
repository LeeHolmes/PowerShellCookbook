##############################################################################
##
## SelectiveCommands.psm1
## Demonstrates the selective export of module commands
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

## An internal helper function
function MyInternalHelperFunction
{
    "Result from my internal helper function"
}

## A command exported from the module
function Get-SelectiveCommandInfo
{
    "Getting information from the SelectiveCommands module"
    MyInternalHelperFunction
}

## Alternate names for our standard command
Set-Alias gsci Get-SelectiveCommandInfo
Set-Alias DomainSpecificVerb-Info Get-SelectiveCommandInfo

## Export specific commands
Export-ModuleMember -Function Get-SelectiveCommandInfo
Export-ModuleMember -Alias gsci,DomainSpecificVerb-Info