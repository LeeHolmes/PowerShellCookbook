##############################################################################
##
## PersistentState.psm1
## Demonstrates persistent state through module-scoped variables
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

$SCRIPT:memory = $null

function Set-Memory
{
    param(
        [Parameter(ValueFromPipeline = $true)]
        $item
    )

    begin { $SCRIPT:memory = New-Object System.Collections.ArrayList }
    process { $null = $memory.Add($item) }
}

function Get-Memory
{
    $memory.ToArray()
}

Set-Alias remember Set-Memory
Set-Alias recall Get-Memory

Export-ModuleMember -Function Set-Memory,Get-Memory
Export-ModuleMember -Alias remember,recall