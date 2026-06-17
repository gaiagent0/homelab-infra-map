Write-Output "=== Foundry Local NPU model inditas ==="
Write-Output "Elerheto NPU modellek:"
foundry model list --device npu 2>&1 | Select-String "NPU"

Write-Output "`n=== qwen2.5-7b NPU inditas ==="
foundry model run qwen2.5-7b-instruct-qnn-npu:1 --prompt "Say hello in 5 words" 2>&1
