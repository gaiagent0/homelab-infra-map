# Foundry Local model run teszt
Write-Output "=== 1. Model lista ==="
foundry model list 2>&1 | Select-String "NPU|qnn" | Select-Object -First 10

Write-Output "`n=== 2. qwen2.5-1.5b NPU run ==="
foundry model run qwen2.5-1.5b-instruct-qnn-npu:2 --prompt "Hello, reply in 5 words" --device NPU 2>&1 | Select-Object -First 20

Write-Output "`n=== 3. qwen2.5-7b NPU run ==="
foundry model run qwen2.5-7b-instruct-qnn-npu:3 --prompt "What is 2+2?" --device NPU 2>&1 | Select-Object -First 20
