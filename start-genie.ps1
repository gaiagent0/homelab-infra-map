# Genie modellek ellenorzese es GenieAPI inditas
Write-Output "=== 1. E:\models\genie tartalom ==="
if (Test-Path 'E:\models\genie') {
    Get-ChildItem 'E:\models\genie' -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "NEM LETEZIK: E:\models\genie"
    Write-Output "`nE meghajtó tartalom:"
    Get-ChildItem 'E:\' -Directory | Select-Object Name
}

Write-Output "`n=== 2. GenieAPIService inditas ==="
$svcExe = 'C:\AI\apps\GenieAPIService_cpp\GenieAPIService.exe'
$svcDir = 'C:\AI\apps\GenieAPIService_cpp'
$logFile = 'C:\AI\logs\genie-api.log'

if (-not (Test-Path 'C:\AI\logs')) {
    New-Item -ItemType Directory -Path 'C:\AI\logs' -Force | Out-Null
}

# Environment
$env:PATH = "C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\bin\aarch64-windows-msvc;C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\lib\aarch64-windows-msvc;$env:PATH"

Write-Output "Inditas: $svcExe"
Start-Process -FilePath $svcExe -WorkingDirectory $svcDir -RedirectStandardOutput $logFile -RedirectStandardError $logFile -WindowStyle Hidden
Start-Sleep -Seconds 10

Write-Output "`n=== 3. GenieAPI process ==="
Get-Process | Where-Object {$_.ProcessName -match 'Genie|genie'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 4. Port 8912 ==="
Get-NetTCPConnection -State Listen -LocalPort 8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize

Write-Output "`n=== 5. Log ==="
if (Test-Path $logFile) {
    Get-Content $logFile -Tail 20
} else {
    Write-Output "Nincs log fajl"
}
