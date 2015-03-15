##############################################################################
##
## TabExpansion2
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

function TabExpansion2
{
    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    Param(
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
        [string] $inputScript,
    
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 1)]
        [int] $cursorColumn,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
        [System.Management.Automation.Language.Ast] $ast,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.Token[]] $tokens,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
        [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,
    
        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
        [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
        [Hashtable] $options = $null
    )

    End
    {
        ## Create a new 'Options' hashtable if one has not been supplied.
        ## In this hashtable, you can add keys for the following options, using
        ## $true or $false for their values:
        ##
        ## IgnoreHiddenShares - Ignore hidden UNC shares (such as \\COMPUTER\ADMIN$)
        ## RelativePaths - When expanding filenames and paths, $true forces PowerShell
        ##     to replace paths with relative paths. When $false, forces PowerShell to
        ##     replace them with absolute paths. By default, PowerShell makes this
        ##     decision based on what you had typed so far before invoking tab completion.
        ## LiteralPaths - Prevents PowerShell from replacing special file characters
        ##     (such as square brackets and back-ticks) with their escaped equivalent.
        if(-not $options) { $options = @{} }

        ## Demonstrate some custom tab expansion completers for parameters.
        ## This is a hash table of parameter names (and optionally cmdlet names)
        ## that we add to the $options hashtable.
        ##
        ## When PowerShell evaluates the script block, $args gets the
        ## following: command name, parameter, word being completed,
        ## AST of the command being completed, and currently-bound arguments.
        $options["CustomArgumentCompleters"] = @{
            "Get-ChildItem:Filter" = { "*.ps1","*.txt","*.doc" }
            "ComputerName" = { "ComputerName1","ComputerName2","ComputerName3" }
        }

        ## Also define a completer for a native executable.
        ## When PowerShell evaluates the script block, $args gets the
        ## word being completed, and AST of the command being completed.
        $options["NativeArgumentCompleters"] = @{
            "attrib" = { "+R","+H","+S" }
        }

        ## Define a "quick completions" list that we'll cycle through
        ## when the user types '!!' followed by TAB.
        $quickCompletions = @(
            'Get-Process -Name PowerShell | ? Id -ne $pid | Stop-Process',
            'Set-Location $pshome',
            ('$errors = $error | % { $_.InvocationInfo.Line }; Get-History | ' +
                ' ? { $_.CommandLine -notin $errors }')
        )

        ## First, check the built-in tab completion results
        $result = $null
        if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet')
        {
            $result = [System.Management.Automation.CommandCompletion]::CompleteInput(
                <#inputScript#>  $inputScript,
                <#cursorColumn#> $cursorColumn,
                <#options#>      $options)
        }
        else
        {
            $result = [System.Management.Automation.CommandCompletion]::CompleteInput(
                <#ast#>              $ast,
                <#tokens#>           $tokens,
                <#positionOfCursor#> $positionOfCursor,
                <#options#>          $options)
        }

        ## If we didn't get a result
        if($result.CompletionMatches.Count -eq 0)
        {
            ## If this was done at the command-line or in a remote session,
            ## create an AST out of the input
            if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet')
            {
                $ast = [System.Management.Automation.Language.Parser]::ParseInput(
                    $inputScript, [ref]$tokens, [ref]$null)
            }

            ## In this simple example, look at the text being supplied.
            ## We could do advanced analysis of the AST here if we wanted,
            ## but in this case just use its text. We use a regular expression
            ## to check if the text started with two exclamations, and then
            ## use a match group to retain the rest.
            $text = $ast.Extent.Text
            if($text -match '^!!(.*)')
            {
                ## Extract the rest of the text from the regular expression
                ## match group.
                $currentCompletionText = $matches[1].Trim()

                ## Go through each of our quick completions and add them to
                ## our completion results. The arguments to the completion results
                ## are the text to be used in tab completion, a potentially shorter
                ## version to use for display (i.e.: intellisense in the ISE),
                ## the type of match, and a potentially more verbose description to
                ## be used as a tool tip.
                $quickCompletions | Where-Object { $_ -match $currentCompletionText } |
                    Foreach-Object { $result.CompletionMatches.Add(
                        (New-Object Management.Automation.CompletionResult $_,$_,"Text",$_) )
                }
            }
        }

        return $result
    }     
}