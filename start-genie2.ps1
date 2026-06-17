# Genie modellek ellenorzese es GenieAPI inditas
Write-Output "=== 1. E meghajtó tartalom ==="
Get-ChildItem 'E:\' | Select-Object Name, PSIsContainer | Format-Table -AutoSize

Write-Output "`n=== 2. Genie modellek keresese ==="
Get-ChildItem 'E:\' -Recurse -Filter 'Qwen2.5-7B' -Directory -ErrorAction SilentlyContinue | Select-Object FullName
Get-ChildItem 'C:\' -Recurse -Filter 'Qwen2.5-7B' -Directory -ErrorAction SilentlyContinue | Select-Object FullName -First 5

Write-Output "`n=== 3. GenieAPIService inditas (egyszeru) ==="
$svcExe = 'C:\AI\apps\GenieAPIService_cpp\GenieAPIService.exe'
$svcDir = 'C:\AI\apps\GenieAPIService_cpp'

$env:PATH = "C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\bin\aarch64-windows-msvc;C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\lib\aarch64-windows-msvc;$env:PATH"

Start-Process -FilePath $svcExe -WorkingDirectory $svcDir -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Output "`n=== 4. GenieAPI process ==="
Get-Process | Where-Object {$_.ProcessName -match 'Genie|genie'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 5. Port 8912 ==="
Get-NetTCPConnection -State Listen -LocalPort 8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize
