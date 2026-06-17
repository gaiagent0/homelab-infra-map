# HF cache atallitas es bge-reranker-v2-m3 letoltes
$env:HF_HOME = "D:\hf_cache"
$env:HF_HUB_CACHE = "D:\hf_cache\hub"

Write-Output "=== HF cache uj helye: D:\hf_cache ==="
Write-Output "HF_HOME: $env:HF_HOME"
Write-Output "HF_HUB_CACHE: $env:HF_HUB_CACHE"

$modelName = "BAAI/bge-reranker-v2-m3"
$targetDir = "D:\models\ONNX\bge-reranker-v2-m3"

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Write-Output "`n=== Letoltes: $modelName ==="
hf download $modelName --local-dir "$targetDir\hf" --local-dir-use-symlinks False 2>&1

Write-Output "`n=== Letolt fajlok ==="
if (Test-Path "$targetDir\hf") {
    Get-ChildItem "$targetDir\hf" -Recurse -File | Where-Object {$_.Length > 1MB} | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "NEM LETEZIK"
}
