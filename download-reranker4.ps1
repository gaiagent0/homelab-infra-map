$env:HF_HOME = "D:\hf_cache"
$env:HF_HUB_CACHE = "D:\hf_cache\hub"

$modelName = "BAAI/bge-reranker-v2-m3"
$targetDir = "D:\models\ONNX\bge-reranker-v2-m3"

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Write-Output "=== Letoltes: $modelName ==="
hf download $modelName --local-dir "$targetDir\hf" --force-download 2>&1

Write-Output "`n=== Letolt fajlok (>1MB) ==="
if (Test-Path "$targetDir\hf") {
    Get-ChildItem "$targetDir\hf" -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
}
