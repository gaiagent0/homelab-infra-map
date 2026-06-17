# NPU kornyezet allapotfelmeres
Write-Output "=== 1. NPU hardware ==="
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List

Write-Output "`n=== 2. Foundry service ==="
foundry service status 2>&1

Write-Output "`n=== 3. Portok ==="
Get-NetTCPConnection -State Listen -LocalPort 5272,8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize

Write-Output "`n=== 4. GenieAPI process ==="
Get-Process | Where-Object {$_.ProcessName -match 'Genie|genie'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 5. Foundry process ==="
Get-Process | Where-Object {$_.ProcessName -match 'foundry|python'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, Path | Format-Table -AutoSize -Wrap

Write-Output "`n=== 6. QAIRT SDK path ==="
Test-Path 'C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\bin\aarch64-windows-msvc'

Write-Output "`n=== 7. Genie models config ==="
Get-ChildItem 'C:\AI\apps\GenieAPIService_cpp\config' -Directory | Select-Object Name

Write-Output "`n=== 8. Genie chat config ==="
Get-Content 'C:\AI\apps\genie-chat\config\qwen25-7b.json' 2>&1
