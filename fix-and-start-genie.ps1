# Genie modellek ellenorzese es config javitas
Write-Output "=== 1. C:\AI\genie_bundle tartalom ==="
Get-ChildItem 'C:\AI\genie_bundle' -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 2. Qwen2.5-7B model fajlok ==="
Get-ChildItem 'C:\AI\genie_bundle\Qwen2.5-7B' -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 3. Genie chat config javitas (E: -> C:) ==="
$configPath = 'C:\AI\apps\genie-chat\config\qwen25-7b.json'
$config = Get-Content $configPath -Raw
$configNew = $config -replace 'E:\\\\models\\\\genie', 'C:\AI\genie_bundle'
Set-Content -Path $configPath -Value $configNew -Encoding UTF8
Write-Output "Config javitva: $configPath"

Write-Output "`n=== 4. GenieAPIService config javitas ==="
$serviceConfigs = Get-ChildItem 'C:\AI\apps\GenieAPIService_cpp\config\Qwen2.5-7B' -File
foreach ($f in $serviceConfigs) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match 'E:\\\\models\\\\genie') {
        $contentNew = $content -replace 'E:\\\\models\\\\genie', 'C:\AI\genie_bundle'
        Set-Content -Path $f.FullName -Value $contentNew -Encoding UTF8
        Write-Output "Javitva: $($f.Name)"
    } else {
        Write-Output "OK (modositatlan): $($f.Name)"
    }
}

Write-Output "`n=== 5. GenieAPIService inditas ==="
$svcExe = 'C:\AI\apps\GenieAPIService_cpp\GenieAPIService.exe'
$svcDir = 'C:\AI\apps\GenieAPIService_cpp'
$env:PATH = "C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\bin\aarch64-windows-msvc;C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\lib\aarch64-windows-msvc;$env:PATH"
Start-Process -FilePath $svcExe -WorkingDirectory $svcDir -WindowStyle Normal
Start-Sleep -Seconds 12

Write-Output "`n=== 6. GenieAPI process ==="
Get-Process | Where-Object {$_.ProcessName -match 'Genie|genie'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 7. Port 8912 ==="
Get-NetTCPConnection -State Listen -LocalPort 8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize
