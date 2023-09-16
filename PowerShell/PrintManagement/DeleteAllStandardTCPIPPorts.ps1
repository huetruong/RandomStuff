# Get all printer ports and delete the standard TCP/IP ports

# Get all printer ports
$ports = Get-PrinterPort

# Define the regex pattern for an IP address followed by an optional underscore and two digits
$pattern = '^([0-9]{1,3}\.){3}[0-9]{1,3}(_[0-9]{2})?'

foreach ($port in $ports) {
    # Check if the port name matches the IP address pattern
    if ($port.Name -match $pattern) {
        Write-Output "Port Name: $($port.Name)"

        # Delete port
        try {
            Remove-PrinterPort -Name $port.Name -WhatIf
            Write-Output "Would delete port: $($port.Name)"
        } catch {
            Write-Output "Failed to delete port: $($port.Name)"
        }
    }
}
