Write-Output "=== GenieAPIService inditas ==="
$svcDir = 'C:\AI\apps\GenieAPIService_cpp'
$env:PATH = "C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\bin\aarch64-windows-msvc;C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\lib\aarch64-windows-msvc;$env:PATH"
Start-Process -FilePath "$svcDir\GenieAPIService.exe" -WorkingDirectory $svcDir -WindowStyle Normal
Start-Sleep -Seconds 12

Write-Output "`n=== Genie process ==="
Get-Process | Where-Object {$_.ProcessName -match 'Genie|genie'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== Port 8912 ==="
Get-NetTCPConnection -State Listen -LocalPort 8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize
