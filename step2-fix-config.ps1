# Genie chat config javitas
Write-Output "=== 1. Genie chat config javitas ==="
$configPath = 'C:\AI\apps\genie-chat\config\qwen25-7b.json'
$content = Get-Content $configPath -Raw
$contentNew = $content -replace 'E:\\models\\genie\\', 'C:\AI\genie_bundle\'
Set-Content -Path $configPath -Value $contentNew -Encoding UTF8
Write-Output "Chat config javitva"

# Service config javitas
Write-Output "`n=== 2. Service config javitas ==="
$cfgDir = 'C:\AI\apps\GenieAPIService_cpp\config\Qwen2.5-7B'
$files = Get-ChildItem $cfgDir -File
foreach ($f in $files) {
    $c = Get-Content $f.FullName -Raw
    if ($c -match 'E:\\') {
        $cn = $c -replace 'E:\\models\\genie\\', 'C:\AI\genie_bundle\'
        Set-Content -Path $f.FullName -Value $cn -Encoding UTF8
        Write-Output "Javitva: $($f.FullName)"
    } else {
        Write-Output "OK: $($f.Name)"
    }
}

# HTP backend config javitas
Write-Output "`n=== 3. HTP backend config javitas ==="
$htpCfg = 'C:\AI\apps\GenieAPIService_cpp\htp_backend_ext_config.json'
if (Test-Path $htpCfg) {
    $c = Get-Content $htpCfg -Raw
    if ($c -match 'E:\\') {
        $cn = $c -replace 'E:\\models\\genie\\', 'C:\AI\genie_bundle\'
        Set-Content -Path $htpCfg -Value $cn -Encoding UTF8
        Write-Output "HTP config javitva"
    }
}

# Chat HTP config javitas
$htpChat = 'C:\AI\apps\genie-chat\config\htp_backend_ext.json'
if (Test-Path $htpChat) {
    $c = Get-Content $htpChat -Raw
    if ($c -match 'E:\\') {
        $cn = $c -replace 'E:\\models\\genie\\', 'C:\AI\genie_bundle\'
        Set-Content -Path $htpChat -Value $cn -Encoding UTF8
        Write-Output "Chat HTP config javitva"
    }
}
