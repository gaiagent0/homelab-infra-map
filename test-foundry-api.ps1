# Foundry Local teszteles
Write-Output "=== 1. Port 5272 ==="
Get-NetTCPConnection -State Listen -LocalPort 5272 -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess | Format-Table

Write-Output "`n=== 2. foundry CLI model lista ==="
foundry model list 2>&1

Write-Output "`n=== 3. foundry CLI run (qwen2.5-7b) ==="
foundry run qwen2.5-7b --prompt "Hello, reply in 5 words" --max-tokens 50 2>&1
