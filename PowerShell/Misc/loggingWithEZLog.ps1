<#
.SYNOPSIS
  This script demonstrates how to use the ezlog module to log messages to a file and to the console.

.DESCRIPTION
  The script imports the ezlog module and sets the default values for the Write-EZLog cmdlet parameters. 
  It then logs an informational message, a warning message, and an error message to a log file and to the console.

.PARAMETER LogFile
  Specifies the path and name of the log file. The default value is 'c:\temp\mylogfile.log'.

.PARAMETER Delimiter
  Specifies the delimiter to use when writing log entries. The default value is ';'.

.PARAMETER ToScreen
  Specifies whether to write log entries to the console. The default value is $true.

.EXAMPLE
  PS C:\> .\loggingwithezlog.ps1
  This example logs messages to a file and to the console.

.NOTES
  See my blog post at https://huetruong.com/easy-powershell-logging-with-ezlog/

#>

# Import the ezlog module
Import-Module ezlog

$LogFile = 'c:\temp\mylogfile.log'

$PSDefaultParameterValues = @{ 'Write-EZLog:LogFile' = $LogFile;
  'Write-EZLog:Delimiter' = ';';
  'Write-EZLog:ToScreen' = $true
}

Write-EZLog -Header
Write-EZLog -Category INF -Message 'This is an info to be written in the log file'
Write-EZLog -Category WAR -Message 'This is a warning to be written in the log file'
Write-EZLog -Category ERR -Message 'This is an error to be written in the log file'
Write-EZLog -Footer