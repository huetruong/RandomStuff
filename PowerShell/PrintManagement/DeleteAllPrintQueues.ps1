# Get all printers and delete all of them

$printers = Get-Printer

foreach ($printer in $printers) {
    Write-Output "Printer Name: $($printer.Name)"

    # Delete printer
    try {
        Remove-Printer -Name $printer.Name -WhatIf
        Write-Output "Would delete printer: $($printer.Name)"
    } catch {
        Write-Output "Failed to delete printer: $($printer.Name)"
    }
}
