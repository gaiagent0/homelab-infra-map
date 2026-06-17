# Foundry Local NPU model inditasa
Write-Output "=== 1. NPU model inditasa (qwen2.5-7b-instruct-qnn-npu:1) ==="
foundry model run qwen2.5-7b-instruct-qnn-npu:1 --prompt "Hello, reply in 5 words" 2>&1 | Select-String -Pattern "Hello|reply|5 words|Done|Error|Generated"

Write-Output "`n=== 2. Port 5272 ellenorzese ==="
Get-NetTCPConnection -State Listen -LocalPort 5272 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize

Write-Output "`n=== 3. API teszt (curl) ==="
curl -s http://localhost:5272/v1/models 2>&1 | python -c "import sys,json; d=json.load(sys.stdin); print('Models:', [m['id'] for m in d.get('data',[])])" 2>&1
