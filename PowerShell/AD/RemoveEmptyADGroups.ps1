[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$csvFile
)

# Import the CSV file with the list of AD group names
$ADGroups = Import-Csv -Path $csvFile

# Create an empty array to store the names of empty groups
$emptyADGroups = @()

# Loop through the list of AD group names
foreach ($group in $ADGroups) {
  # Get the group object from Active Directory
  $adGroup = Get-ADGroup -Identity $group.DistinguishedName -Properties Members
  Write-Verbose "Checking $($group.Name)..."

  # Check if the group has no members
  if ($adGroup.Members.Count -eq 0) {
    # Add the group name to the emptyGroups array
    $emptyADGroups += $group.Name
    Write-Verbose "$($group.Name) is empty."

    # Delete the group with -WhatIf
    Remove-ADGroup -Identity $group.DistinguishedName -Confirm:$false -WhatIf 
  } else {
    Write-Verbose "$($group.Name) is not empty."
  }
}

# Export the names of empty groups to a CSV file
if ($emptyADGroups.Count -gt 0) {
  Write-Output "There were $($emptyADGroups.Count) empty groups."
  $emptyADGroups = $emptyADGroups | Select-Object @{ Name = 'Name'; Expression = { $_ } }
  $emptyADGroups | ConvertTo-Csv -NoTypeInformation -Delimiter "," | ForEach-Object { $_ -replace '\"','' } | Out-File "$(Get-Date -Format "yyyyMMddHHmmss") Deleted AD Groups.csv"
} else {
  Write-Output "No empty groups found."
}
