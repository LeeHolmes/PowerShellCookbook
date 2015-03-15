## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)

Set-StrictMode -Version 3

## Get the size of all the items in the current directory
function Get-DirectorySize
{
    <#

    .EXAMPLE

    PS > $DebugPreference = "Continue"
    PS > Get-DirectorySize
    DEBUG: Current Directory: D:\lee\OReilly\Scripts\Programs
    Directory size: 46,581 bytes
    PS > $DebugPreference = "SilentlyContinue"
    PS > $VerbosePreference = "Continue"
    PS > Get-DirectorySize
    VERBOSE: Getting size
    VERBOSE: Got size: 46581
    Directory size: 46,581 bytes
    PS > $VerbosePreference = "SilentlyContinue"

    #>

    Write-Debug "Current Directory: $(Get-Location)"

    Write-Verbose "Getting size"
    $size = (Get-ChildItem | Measure-Object -Sum Length).Sum
    Write-Verbose "Got size: $size"

    Write-Host ("Directory size: {0:N0} bytes" -f $size)
}

## Get the list of items in a directory, sorted by length
function Get-ChildItemSortedByLength($path = (Get-Location), [switch] $Problematic)
{
    <#
    
    .EXAMPLE

    PS > Get-ChildItemSortedByLength -Problematic
    out-lineoutput : Object of type "Microsoft.PowerShell.Commands.Internal.Fo
    rmat.FormatEntryData" is not legal or not in the correct sequence. This is
    likely caused by a user-specified "format-*" command which is conflicting
    with the default formatting.

    #>

    if($Problematic)
    {
        ## Problematic version
        Get-ChildItem $path | Format-Table | Sort Length
    }
    else
    {
        ## Fixed version
        Get-ChildItem $path | Sort Length | Format-Table
    }
}