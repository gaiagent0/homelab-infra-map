# GenieAPI (NPU) inditas es teszteles
Write-Output "=== 1. GenieAPIService inditasa (port 8912) ==="
$svcExe = 'C:\AI\apps\GenieAPIService_cpp\GenieAPIService.exe'
$svcLog = 'C:\AI\logs\genie-api.log'
if (-not (Test-Path $svcLog)) {
    New-Item -ItemType File -Path $svcLog -Force | Out-Null
}
Start-Process -FilePath $svcExe -RedirectStandardOutput $svcLog -RedirectStandardError $svcLog -WindowStyle Hidden
Write-Output "GenieAPIService inditva. Varakozas..."
Start-Sleep -Seconds 8

Write-Output "`n=== 2. Port 8912 ellenorzese ==="
Get-NetTCPConnection -State Listen -LocalPort 8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize

Write-Output "`n=== 3. Genie Chat inditasa (port 8912 API hasznalataval) ==="
$chatPy = 'C:\AI\apps\genie-chat\genie_chat.py'
$python = 'C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe'
Start-Process -FilePath $python -ArgumentList $chatPy -WindowStyle Normal
Write-Output "Genie Chat elindult. Belepes: http://localhost:8912/v1"
