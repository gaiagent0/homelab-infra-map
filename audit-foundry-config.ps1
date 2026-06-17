# Foundry Local konfiguracio es cache vizsgalat
Write-Output "=== 1. Foundry Local config fajlok ==="
$foundryLocalDir = "C:\Users\istva\AppData\Local\Packages\Microsoft.FoundryLocal_8wekyb3d8bbwe"
Get-ChildItem $foundryLocalDir -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Extension -match '\.json$|\.yaml$|\.yml$|\.toml$|\.cfg$|\.ini$|\.conf$'} | Select-Object FullName, @{N='SizeKB';E={[math]::Round($_.Length/1KB,1)}} | Format-Table -AutoSize -Wrap

Write-Output "`n=== 2. foundry.modelinfo.json tartalom (elso 50 sor) ==="
$modelInfo = "D:\models\Foundry\foundry.modelinfo.json"
if (Test-Path $modelInfo) {
    Get-Content $modelInfo -Head 50
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== 3. Foundry Local registry beallitasok ==="
$regPath = "HKCU:\Software\Microsoft\FoundryLocal"
if (Test-Path $regPath) {
    Get-ItemProperty $regPath | Format-List
} else {
    Write-Output "NINCS REGISTRY KULCS"
}

Write-Output "`n=== 4. Foundry CLI config ==="
foundry config list 2>&1
