<#
.SYNOPSIS
    This script retrieves the last login time for all Active Directory users and exports the inactive users to a CSV file.
.DESCRIPTION
    This script retrieves the last login time for all Active Directory users and exports the inactive users to a CSV file. 
    The number of days after which a user is considered inactive can be set by modifying the $daysInactive variable.
.PARAMETER daysInactive
    The number of days after which a user is considered inactive. Default value is 30.
.PARAMETER csvFile
    The file path and name of the CSV file to export the inactive users to. Default value is the current date and time in the format "yyyy-MM-dd-HHmmss" followed by " Inactive Users.csv".
.EXAMPLE
    .\GetinactiveADUsers.ps1
    Retrieves the last login time for all Active Directory users and exports the inactive users to a CSV file.
.NOTES
    Author: Hue Truong
    Date: 10/25/2023
    Version: 1.0.0
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [System.Int32]$daysInactive = 30,
  [string]$csvFile = (Get-Date -Format "yyyy-MM-dd-HHmmss") + " Inactive Users.csv"
)

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Get all AD users
Write-Verbose "Getting all AD users..."
$users = Get-ADUser -Filter * -Properties Description,LastLogonTimestamp

$inactiveUsers = @()

Write-Verbose "Getting active users..."
# Loop through each user
foreach ($user in $users) {

  if ($user.Enabled -eq $true) {

    Write-Verbose "Working on $($user.name)"
    Write-Verbose "DistingushedName = $($user.DistinguishedName)"
    Write-Verbose "SamACcountName = $($user.SamAccountName)"
    Write-Verbose "UserPrincipalName = $($user.UserPrincipalName)"

    # Get the user's last login time
    $lastLogon = Get-ADUser $user -Properties LastLogonTimestamp | Select-Object -ExpandProperty LastLogonTimestamp

    if ($lastLogon) {
      # Convert the last login time to a DateTime object
      $lastLogonDate = [datetime]::FromFileTime($lastLogon)

      # Calculate the number of days since the user's last login
      $daysSinceLastLogon = (Get-Date) - $lastLogonDate
      Write-Verbose "Days since last logon: $daysSinceLastLogon"
    }
    else {
      $daysSinceLastLogon = -1
      Write-Verbose "Days since last logon: Never"
    }

    # If the number of days is greater than the specified number of days, add the user to the inactive users object
    if (($daysSinceLastLogon.Days -gt $daysInactive) -or ($daysSinceLastLogon -eq -1)) {
      if ($daysSinceLastLogon -eq -1) {
        $lastLogonDate = "Never"
      } else {
        $lastLogonDate = $lastLogonDate.ToString("MM-dd-yyyy")
        Write-Verbose "Last logon date: $lastLogonDate"
      }
      $userObject = [pscustomobject]@{
        Name = $user.Name
        SamAccountName = $user.SamAccountName
        UserPrincipalName = $user.UserPrincipalName
        DistinguishedName = $user.DistinguishedName
        Description = $user.Description
        LastLogon = $lastLogonDate
      }
      $inactiveUsers += $userObject
      Write-Verbose "Added $($user.Name) to inactive users object"
    }
  }
}

Write-Verbose "Exporting inactive users to $csvFile"
# Export the custom objects of empty groups to a CSV file
if ($inactiveUsers.Count -gt 0) {
  $inactiveUsers | Export-Csv -Path $csvFile -NoTypeInformation
}
