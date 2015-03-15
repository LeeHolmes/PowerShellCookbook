##############################################################################
##
## PlottingObject.psm1
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Demonstrates a module designed to be imported as a custom object

.EXAMPLE

Remove-Module PlottingObject
function SineWave { -15..15 | % { ,($_,(10 * [Math]::Sin($_ / 3))) } }
function Box { -5..5 | % { ($_,-5),($_,5),(-5,$_),(5,$_) } }

$obj = Import-Module PlottingObject -AsCustomObject
$obj.Move(10,10)

$obj.Points = SineWave
while($true) { $obj.Rotate(10); $obj.Draw(); Sleep -m 20 }

$obj.Points = Box
while($true) { $obj.Rotate(10); $obj.Draw(); Sleep -m 20 }

#>

## Declare some internal variables
$SCRIPT:x = 0
$SCRIPT:y = 0
$SCRIPT:angle = 0
$SCRIPT:xScale = -50,50
$SCRIPT:yScale = -50,50

## And a variable that we will later export
$SCRIPT:Points = @()
Export-ModuleMember -Variable Points

## A function to rotate the points by a certain amount
function Rotate($angle)
{
    $SCRIPT:angle += $angle
}
Export-ModuleMember -Function Rotate

## A function to move the points by a certain amount
function Move($xDelta, $yDelta)
{
    $SCRIPT:x += $xDelta
    $SCRIPT:y += $yDelta
}
Export-ModuleMember -Function Move

## A function to draw the given points
function Draw
{
    $degToRad = 180 * [Math]::Pi
    Clear-Host

    ## Draw the origin
    PutPixel 0 0 +

    ## Go through each of the supplied points,
    ## move them the amount specified, and then rotate them
    ## by the angle specified
    foreach($point in $points)
    {
        $pointX,$pointY = $point
        $pointX = $pointX + $SCRIPT:x
        $pointY = $pointY + $SCRIPT:y

        $newX = $pointX * [Math]::Cos($SCRIPT:angle / $degToRad ) -
            $pointY * [Math]::Sin($SCRIPT:angle / $degToRad )
        $newY = $pointY * [Math]::Cos($SCRIPT:angle / $degToRad ) +
            $pointX * [Math]::Sin($SCRIPT:angle / $degToRad )

        PutPixel $newX $newY O
    }

    [Console]::WriteLine()
}
Export-ModuleMember -Function Draw

## A helper function to draw a pixel on the screen
function PutPixel($x, $y, $character)
{
    $scaledX = ($x - $xScale[0]) / ($xScale[1] - $xScale[0])
    $scaledX *= [Console]::WindowWidth

    $scaledY = (($y * 4 / 3) - $yScale[0]) / ($yScale[1] - $yScale[0])
    $scaledY *= [Console]::WindowHeight

    try
    {
        [Console]::SetCursorPosition($scaledX,
            [Console]::WindowHeight - $scaledY)
        [Console]::Write($character)
    }
    catch
    {
        ## Take no action on error. We probably just rotated a point
        ## out of the screen boundary.
    }
}