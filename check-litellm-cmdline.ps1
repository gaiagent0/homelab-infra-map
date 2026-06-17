# LiteLLM inditas modja
Get-Process -Id 11164 | Select-Object ProcessName, Id, Path, @{N='CmdLine';E={(Get-CimInstance Win32_Process -Filter "ProcessId=11164").CommandLine}} | Format-List
Get-Process -Id 36388 | Select-Object ProcessName, Id, Path, @{N='CmdLine';E={(Get-CimInstance Win32_Process -Filter "ProcessId=36388").CommandLine}} | Format-List
Get-Process -Id 2220 | Select-Object ProcessName, Id, Path, @{N='CmdLine';E={(Get-CimInstance Win32_Process -Filter "ProcessId=2220").CommandLine}} | Format-List
Get-Process -Id 23172 | Select-Object ProcessName, Id, Path, @{N='CmdLine';E={(Get-CimInstance Win32_Process -Filter "ProcessId=23172").CommandLine}} | Format-List
