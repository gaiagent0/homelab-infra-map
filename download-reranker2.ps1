# bge-reranker-v2-m3 letoltes hf CLI-vel
$modelName = "BAAI/bge-reranker-v2-m3"
$targetDir = "D:\models\ONNX\bge-reranker-v2-m3"

Write-Output "=== hf CLI verzio ==="
hf --version 2>&1

Write-Output "`n=== Letoltes ==="
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

# Letoltes
hf download $modelName --local-dir "$targetDir\hf" 2>&1

Write-Output "`n=== Letolt fajlok ==="
if (Test-Path "$targetDir\hf") {
    Get-ChildItem "$targetDir\hf" -Recurse -File | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "NEM LETEZIK"
}
