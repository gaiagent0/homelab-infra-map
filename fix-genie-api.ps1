# GenieAPI config javitas + inditas
$genieDir = "C:\AI\apps\GenieAPIService_cpp"
$chatDir = "C:\AI\apps\genie-chat"
$modelsDir = "D:\models\genie"

Write-Output "=== 1. Genie modellek D: meghajtón ==="
Get-ChildItem $modelsDir -Directory | ForEach-Object {
    $size = (Get-ChildItem $_.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
    Write-Output "$($_.Name): $([math]::Round($size/1GB,2)) GB"
}

Write-Output "`n=== 2. Service config javitas (E: -> D:) ==="
$serviceConfigs = Get-ChildItem "$genieDir\config" -Recurse -File
foreach ($f in $serviceConfigs) {
    $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($content -match 'E:\\\\models\\\\genie') {
        $newContent = $content -replace 'E:\\\\models\\\\genie', 'D:\models\genie'
        Set-Content -Path $f.FullName -Value $newContent -Encoding UTF8
        Write-Output "Javitva: $($f.FullName)"
    }
}

# HTP backend config
$htpCfg = "$genieDir\htp_backend_ext_config.json"
if (Test-Path $htpCfg) {
    $c = Get-Content $htpCfg -Raw
    if ($c -match 'E:') {
        $cn = $c -replace 'E:\\\\models\\\\genie', 'D:\models\genie'
        Set-Content -Path $htpCfg -Value $cn -Encoding UTF8
        Write-Output "HTP config javitva"
    }
}

Write-Output "`n=== 3. Chat config javitas ==="
$chatCfg = "$chatDir\config\qwen25-7b.json"
if (Test-Path $chatCfg) {
    $c = Get-Content $chatCfg -Raw
    if ($c -match 'E:\\\\models\\\\genie') {
        $cn = $c -replace 'E:\\\\models\\\\genie', 'D:\models\genie'
        Set-Content -Path $chatCfg -Value $cn -Encoding UTF8
        Write-Output "Chat config javitva: $chatCfg"
    } else {
        Write-Output "Chat config OK (nem tartalmaz E: utvonalat)"
    }
}

# HTP chat config
$htpChat = "$chatDir\config\htp_backend_ext.json"
if (Test-Path $htpChat) {
    $c = Get-Content $htpChat -Raw
    if ($c -match 'E:') {
        $cn = $c -replace 'E:\\\\models\\\\genie', 'D:\models\genie'
        Set-Content -Path $htpChat -Value $cn -Encoding UTF8
        Write-Output "Chat HTP config javitva"
    }
}

Write-Output "`n=== 4. GenieAPIService inditas ==="
$env:PATH = "C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\bin\aarch64-windows-msvc;C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\lib\aarch64-windows-msvc;$env:PATH"

# Ellenorizzuk, fut-e mar
$genieProc = Get-Process | Where-Object {$_.ProcessName -match 'GenieAPI'}
if ($genieProc) {
    Write-Output "GenieAPIService mar fut: PID $($genieProc.Id)"
} else {
    Write-Output "GenieAPIService inditasa..."
    Start-Process -FilePath "$genieDir\GenieAPIService.exe" -WorkingDirectory $genieDir -WindowStyle Hidden
    Start-Sleep -Seconds 10
    
    $genieProc = Get-Process | Where-Object {$_.ProcessName -match 'GenieAPI'}
    if ($genieProc) {
        Write-Output "GenieAPIService elindult: PID $($genieProc.Id)"
    } else {
        Write-Output "GenieAPIService inditasa SIKERTELEN"
    }
}

Write-Output "`n=== 5. Port 8912 ellenorzese ==="
Get-NetTCPConnection -State Listen -LocalPort 8912 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize
