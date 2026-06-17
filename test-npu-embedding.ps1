Write-Output "=== NPU environment check ==="
$py = 'C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe'
& $py 'C:\AI\npu\scripts\npu_env_check.py' 2>&1

Write-Output "`n=== NPU embedding teszt ==="
& $py 'C:\AI\npu\scripts\npu_embedding.py' 2>&1
