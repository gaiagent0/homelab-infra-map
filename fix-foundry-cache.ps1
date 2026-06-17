# Foundry Local javitas - modellek hozzaadasa
Write-Output "=== 1. Foundry Local cache struktura ==="
$cacheBase = "C:\Users\istva\AppData\Local\Packages\Microsoft.FoundryLocal_8wekyb3d8bbwe\LocalCache"
if (Test-Path $cacheBase) {
    Get-ChildItem $cacheBase -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
} else {
    Write-Output "NEM LETEZIK: $cacheBase"
    # Keressuk meg a helyet
    Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.FoundryLocal*" -ErrorAction SilentlyContinue | Select-Object FullName
}

Write-Output "`n=== 2. D:\models\Foundry struktura ==="
Get-ChildItem 'D:\models\Foundry' -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
