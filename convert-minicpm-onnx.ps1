# minicpm-layerwise ONNX konvertalas (trust_remote_code)
$env:HF_HOME = "D:\hf_cache"
$py = "C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe"

$hfDir = "D:\models\ONNX\bge-reranker-v2-minicpm-layerwise\hf"
$onnxDir = "D:\models\ONNX\bge-reranker-v2-minicpm-layerwise\onnx"

Write-Output "=== HF tartalom ==="
Get-ChildItem $hfDir -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object Name, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== ONNX konvertalas (trust_remote_code) ==="
$convertPy = @"
from optimum.onnxruntime import ORTModelForSequenceClassification
from transformers import AutoTokenizer
import os, sys

model_path = r"$hfDir"
output_path = r"$onnxDir"

print(f"Betoltes: {model_path}", flush=True)
try:
    model = ORTModelForSequenceClassification.from_pretrained(model_path, export=True, trust_remote_code=True)
    tokenizer = AutoTokenizer.from_pretrained(model_path, trust_remote_code=True)
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
    import traceback
    traceback.print_exc()
    sys.exit(1)
"@
$convertPy | Out-File -FilePath "$onnxDir\convert.py" -Encoding UTF8
& $py "$onnxDir\convert.py" 2>&1
