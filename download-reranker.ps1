# bge-reranker-v2-m3 letoltes es ONNX konvertalas
$modelName = "BAAI/bge-reranker-v2-m3"
$targetDir = "D:\models\ONNX\bge-reranker-v2-m3"

if (Test-Path $targetDir) {
    Write-Output "Mar letezik: $targetDir"
    Get-ChildItem $targetDir -Recurse -File | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "Letoltes: $modelName"
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    
    # HuggingFace letoltes
    $hfc = "$env:USERPROFILE\.cache\huggingface"
    & huggingface-cli download $modelName --local-dir "$targetDir\hf" 2>&1
    
    Write-Output "`nHF cache tartalom:"
    Get-ChildItem "$targetDir\hf" -Recurse -File | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
}

Write-Output "`n=== hf_cache bge-reranker-v2-m3 ==="
$hfReranker = "D:\hf_cache\hub\models--BAAI--bge-reranker-v2-m3"
if (Test-Path $hfReranker) {
    Get-ChildItem $hfReranker -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "NEM LETEZIK"
}
