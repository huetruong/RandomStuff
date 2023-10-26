<#
.SYNOPSIS
This script retrieves all empty Active Directory groups and exports them to a CSV file.

.DESCRIPTION
This script uses the ActiveDirectory module to retrieve all AD groups and filters out built-in security groups and empty groups. It then creates a custom object with the group name, distinguishedname, description, and info, and adds it to an array. Finally, it exports the custom objects of empty groups to a CSV file.

.PARAMETER csvFile
Specifies the name of the CSV file to export the empty groups to. If not specified, the file will be named with the current date and time in the format "yyyy-MM-dd-HHmmss Empty AD Groups.csv".

.EXAMPLE
GetEmptyADGroups.ps1 -csvFile "EmptyGroups.csv"
This example retrieves all empty AD groups and exports them to a file named "EmptyGroups.csv".

.NOTES
Author: Hue Truong
Date: 10/25/2023
Version: 1.0.0
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string]$csvFile = (Get-Date -Format "yyyy-MM-dd-HHmmss") + " Empty AD Groups.csv"
)

# Import the Active Directory module
Import-Module ActiveDirectory

Write-Output "Getting all AD groups..."
# Get all groups
$groups = Get-ADGroup -Filter * -Properties Members

Write-Verbose "Filtering out built-in security groups and empty groups..."
# Filter out built-in security groups and empty groups
$ADGroups = $groups | Where-Object {
  $_.Members.Count -eq 0 -and $_.DistinguishedName -notlike "CN=Builtin,*"
}
Write-Verbose "$($ADGroups.Count) empty groups found."

# Create an empty array to store the names of empty groups
$emptyGroups = @()

# Loop through the list of AD group names
foreach ($group in $ADgroups) {
  # Get the group object from Active Directory
  $adGroup = Get-ADGroup -Filter { Name -EQ $group.Name } -Properties Members,Description,Info,DistinguishedName
  Write-Verbose "Processing $($adGroup.Name)..."

  # Create a custom object with the group name, distinguishedname, description, and info
  $emptyGroup = [pscustomobject]@{
    Name = $adGroup.Name
    DistinguishedName = $adGroup.DistinguishedName
    Description = $adGroup.Description
    Info = $adGroup.Info
  }
  # Add the custom object to the emptyGroups array
  $emptyGroups += $emptyGroup
  Write-Verbose "Added $($adGroup.Name) to the array."
}

# Export the custom objects of empty groups to a CSV file
if ($emptyGroups.Count -gt 0) {
  Write-Output "Exporting empty groups to $csvFile..."
  $emptyGroups | Export-Csv -Path $csvFile -NoTypeInformation
} else {
  Write-Output "No empty groups found."
}
