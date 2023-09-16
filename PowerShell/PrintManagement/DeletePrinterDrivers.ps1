# Remove printer drivers from printerdrivers.csv

# Get printers driver names and save to printerdrivers.csv
# 1. Get-PrinterDriver | select Name | Export-Csv printerdrivers.csv -NoTypeInformation
# 2. Manually edit printerdrivers.csv to remove print drivers you want to keep.
# 3. Then run this PowerShell script to delete printer drivers that you want to delete.

# Import the CSV file
$printerDrivers = Import-Csv -Path 'printerdrivers.csv'

# Loop through each printer driver in the CSV file
foreach ($driver in $printerDrivers) {
    # Try to remove the printer driver
    try {
        Remove-PrinterDriver -Name $driver.Name -WhatIf -ErrorAction Stop
        Write-Output "Would have removed printer driver: $($driver.Name)"
    }
    catch {
        Write-Output "Failed to remove printer driver: $($driver.Name)"
    }
}
