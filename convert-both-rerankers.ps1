# Mindket reranker letoltes es ONNX konvertalas
$env:HF_HOME = "D:\hf_cache"
$env:HF_HUB_CACHE = "D:\hf_cache\hub"
$py = "C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe"

$models = @(
    @{Name="BAAI/bge-reranker-v2-m3"; Dir="D:\models\ONNX\bge-reranker-v2-m3"},
    @{Name="BAAI/bge-reranker-v2-minicpm-layerwise"; Dir="D:\models\ONNX\bge-reranker-v2-minicpm-layerwise"}
)

foreach ($m in $models) {
    $hfDir = Join-Path $m.Dir "hf"
    $onnxDir = Join-Path $m.Dir "onnx"
    
    Write-Output "`n=== $($m.Name) ==="
    
    # Letoltes ha kell
    if (-not (Test-Path $hfDir) -or -not (Test-Path (Join-Path $hfDir "model.safetensors"))) {
        Write-Output "Letoltes..."
        hf download $m.Name --local-dir $hfDir --force-download 2>&1 | Select-Object -Last 5
    } else {
        Write-Output "Mar letezik: $hfDir"
        Get-ChildItem $hfDir -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
    }
    
    # ONNX konvertalas ha kell
    if (-not (Test-Path (Join-Path $onnxDir "model.onnx"))) {
        Write-Output "ONNX konvertalas..."
        if (-not (Test-Path $onnxDir)) {
            New-Item -ItemType Directory -Path $onnxDir -Force | Out-Null
        }
        
        $convertPy = @"
from optimum.onnxruntime import ORTModelForSequenceClassification
from transformers import AutoTokenizer
import os, sys

model_path = r"$hfDir"
output_path = r"$onnxDir"

print(f"Betoltes: {model_path}", flush=True)
try:
    model = ORTModelForSequenceClassification.from_pretrained(model_path, export=True)
    tokenizer = AutoTokenizer.from_pretrained(model_path)
    print(f"Mentes: {output_path}", flush=True)
    model.save_pretrained(output_path)
    tokenizer.save_pretrained(output_path)
    print("KESZ!", flush=True)
    for f in os.listdir(output_path):
        fp = os.path.join(output_path, f)
        if os.path.isfile(fp):
            print(f"  {f}: {os.path.getsize(fp)/1024/1024:.1f} MB", flush=True)
except Exception as e:
    print(f"HIBA: {e}", flush=True)
    sys.exit(1)
"@
        $convertPy | Out-File -FilePath "$onnxDir\convert.py" -Encoding UTF8
        & $py "$onnxDir\convert.py" 2>&1
    } else {
        Write-Output "ONNX mar letezik: $onnxDir"
        Get-ChildItem $onnxDir -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
    }
}
