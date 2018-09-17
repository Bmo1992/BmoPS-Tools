<#
#  Author  : BMO
#  Purpose : Find all users that havn't logged into the Domain in 30 or more days { that arn't disabled } 
#  Created : September 17, 2018
#>

<#
    .SYNOPSIS
      Get-OldUser.ps1 is a script to quickly audit a list of all users who have not signed into the domain in over 30 days.
    .EXAMPLE
#>

[CmdletBinding()]
Param
(

)

# Check to confirm this script is being run by an admin in an elevated powershell prompt or else exit. If run from a non-priviledged
# prompt then powershell will be unabled to read the Enabled AD property thanks to UAC
$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [System.Security.Principal.WindowsPrincipal] $identity
$role = [System.Security.Principal.WindowsBuiltInRole] "Administrator"

# Required module to run the cmdlets in the script
Import-Module ActiveDirectory

########## Variables ############
$daysback = "-30"
$current_date = Get-Date
$month_old = $current_date.AddDays($daysback)
$all_user_objects = Get-ADUser -Filter * -Properties * 

ForEach( $user in $all_user_objects) 
{
    if( $user.LastLogonDate -lt $month_old )
    {
        Write-Output $user.Name
    }
}

