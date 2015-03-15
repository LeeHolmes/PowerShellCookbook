## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)

Set-StrictMode -Version 3

## Return the name of the currently executing script
## By placing this in a function, we drastically simplify
## the logic it takes to determine the currently running
## script

function Get-ScriptName
{
    $myInvocation.ScriptName
}

function Get-ScriptPath
{
    Split-Path $myInvocation.ScriptName
}