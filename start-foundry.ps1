# Foundry Local inditas es teszteles
Write-Output "=== 1. Python SDK ellenorzese ==="
$python = 'C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe'
& $python -c "import foundry_local_sdk; print('SDK OK')" 2>&1

Write-Output "`n=== 2. foundry service start ==="
foundry service start 2>&1

Start-Sleep -Seconds 5

Write-Output "`n=== 3. Service status ==="
foundry service status 2>&1

Write-Output "`n=== 4. Port 5272 ==="
Get-NetTCPConnection -State Listen -LocalPort 5272 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table

Write-Output "`n=== 5. App.py inditas (hatterben) ==="
$appPy = 'C:\AI\apps\Foundry\app.py'
Start-Process -FilePath $python -ArgumentList $appPy -WindowStyle Hidden
Write-Output "app.py inditva. Varakozas..."
Start-Sleep -Seconds 8

Write-Output "`n=== 6. Port 5272 ujra ==="
Get-NetTCPConnection -State Listen -LocalPort 5272 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table

Write-Output "`n=== 7. API teszt ==="
try {
    $r = Invoke-WebRequest -Uri 'http://localhost:5272/v1/models' -TimeoutSec 10
    Write-Output "Status: $($r.StatusCode)"
    Write-Output "Body: $($r.Content.Substring(0, [Math]::Min(500, $r.Content.Length)))"
} catch {
    Write-Output "HIBA: $($_.Exception.Message)"
}
