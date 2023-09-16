# Get all printers and delete printers matching PATTERN
# Need to run PowerShell as Administrator

$printers = Get-Printer

# Define the regex pattern for "PATTERN" followed by any characters
$pattern = '^PATTERN.*'

foreach ($printer in $printers) {
    # Check if the printer name matches the pattern
    if ($printer.Name -match $pattern) {
        Write-Output "Printer Name: $($printer.Name)"

        # Delete printer
        try {
            Remove-Printer -Name $printer.Name -WhatIf
            Write-Output "Would delete printer: $($printer.Name)"
        } catch {
            Write-Output "Failed to delete printer: $($printer.Name)"
        }
    }
}