Write-Output "=== 1. Cache mappa ==="
$cacheDir = "$env:LOCALAPPDATA\FoundryLocal"
if (Test-Path $cacheDir) {
    Get-ChildItem $cacheDir -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "NEM LETEZIK: $cacheDir"
}

Write-Output "`n=== 2. Cache torles es ujrateszt ==="
foundry cache list 2>&1

Write-Output "`n=== 3. Model download (qwen2.5-7b) ==="
foundry model download qwen2.5-7b-instruct-qnn-npu:1 2>&1
