Write-Output "=== NPU modellek ==="
foundry model list 2>&1 | Where-Object { $_ -match 'NPU|qnn' }

Write-Output "`n=== qwen2.5-7b NPU run ==="
foundry model run qwen2.5-7b-instruct-qnn-npu:1 --prompt "Say hello in 5 words" 2>&1
