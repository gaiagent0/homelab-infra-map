# Foundry Local inditas es teszteles
Write-Output "=== 1. foundry CLI ellenorzese ==="
try {
    $ver = foundry --version 2>&1
    Write-Output "foundry CLI: $ver"
} catch {
    Write-Output "HIBA: foundry CLI nincs telepitve"
}

Write-Output "`n=== 2. foundry service status ==="
try {
    $svc = foundry service status 2>&1
    Write-Output "Service: $svc"
} catch {
    Write-Output "HIBA: foundry service nem erheto el"
}

Write-Output "`n=== 3. Python SDK ellenorzese ==="
$python = 'C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe'
try {
    $sdkCheck = & $python -c 'import foundry_local_sdk; print("SDK OK")' 2>&1
    Write-Output "SDK: $sdkCheck"
} catch {
    Write-Output "HIBA: SDK nem importalhato"
}

Write-Output "`n=== 4. Port 5272 ellenorzese ==="
Get-NetTCPConnection -State Listen -LocalPort 5272 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table

Write-Output "`n=== 5. NPU device ellenorzese ==="
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores | Format-List
