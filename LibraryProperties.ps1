##############################################################################
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

filter Get-PropertyValue($property)
{
    $_.$property
}