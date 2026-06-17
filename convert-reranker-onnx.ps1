# bge-reranker-v2-m3 ONNX konvertalas
$hfDir = "D:\models\ONNX\bge-reranker-v2-m3\hf"
$onnxDir = "D:\models\ONNX\bge-reranker-v2-m3\onnx"

if (-not (Test-Path $onnxDir)) {
    New-Item -ItemType Directory -Path $onnxDir -Force | Out-Null
}

Write-Output "=== Safetensors meret ==="
$stFile = Join-Path $hfDir "model.safetensors"
if (Test-Path $stFile) {
    Write-Output "$stFile : $([math]::Round((Get-Item $stFile).Length/1GB,2)) GB"
} else {
    Write-Output "NEM LETEZIK: $stFile"
}

Write-Output "`n=== Python ONNX konvertalas ==="
$py = "C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe"

# Ellenorizzuk, van-e optimum
& $py -c "import optimum; print('optimum:', optimum.__version__)" 2>&1
& $py -c "import onnxruntime; print('ort:', onnxruntime.__version__)" 2>&1

# ONNX konvertalas optimum-mal
$convertScript = @"
from optimum.onnxruntime import ORTModelForSequenceClassification
from transformers import AutoTokenizer
import os

model_path = r"$hfDir"
output_path = r"$onnxDir"

print(f"Betoltes: {model_path}")
model = ORTModelForSequenceClassification.from_pretrained(model_path, export=True)
tokenizer = AutoTokenizer.from_pretrained(model_path)

print(f"Mentes: {output_path}")
model.save_pretrained(output_path)
tokenizer.save_pretrained(output_path)

print("KESZ!")
print("Fajlok:")
for f in os.listdir(output_path):
    fp = os.path.join(output_path, f)
    if os.path.isfile(fp):
        print(f"  {f}: {os.path.getsize(fp)/1024/1024:.1f} MB")
"@

$convertScript | Out-File -FilePath "$onnxDir\convert.py" -Encoding UTF8

Write-Output "`n=== Konvertalas inditasa ==="
& $py "$onnxDir\convert.py" 2>&1
