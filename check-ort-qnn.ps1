# ONNX Runtime QNN EP telepites es teszt
$py = "C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe"

Write-Output "=== Jelenlegi ONNX Runtime ==="
& $py -c "import onnxruntime as ort; print('Version:', ort.__version__); print('Providers:', ort.get_available_providers())" 2>&1

Write-Output "`n=== QAIRT SDK ONNX Runtime ==="
$qairtBase = "C:\Qualcomm\AIStack\QAIRT\2.45.40.260406"
$ortQnn = Join-Path $qairtBase "lib\python"
Write-Output "QAIRT Python path: $ortQnn"
if (Test-Path $ortQnn) {
    Get-ChildItem $ortQnn -Recurse -Filter "onnxruntime*" | Select-Object FullName
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== onnxruntime-qnn keresese ==="
pip index versions onnxruntime-qnn 2>&1 | Select-Object -First 5
