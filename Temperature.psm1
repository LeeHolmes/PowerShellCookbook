##############################################################################
##
## Temperature.psm1
## Commands that manipulate and convert temperatures
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

## Convert Fahrenheit to Celcius
function Convert-FahrenheitToCelcius([double] $fahrenheit)
{
    $celcius = $fahrenheit - 32
    $celcius = $celcius / 1.8
    $celcius
}

## Convert Celcius to Fahrenheit
function Convert-CelciusToFahrenheit([double] $celcius)
{
    $fahrenheit = $celcius * 1.8
    $fahrenheit = $fahrenheit + 32
    $fahrenheit
}