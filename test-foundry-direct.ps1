# Foundry Local API kozvetlen teszteles
Write-Output "=== 1. Service status ==="
foundry service status 2>&1

Write-Output "`n=== 2. API status ==="
try {
    $r = Invoke-WebRequest -Uri 'http://127.0.0.1:5272/openai/status' -TimeoutSec 10
    Write-Output "Status: $($r.StatusCode)"
    Write-Output $r.Content
} catch {
    Write-Output "HIBA: $($_.Exception.Message)"
}

Write-Output "`n=== 3. Chat completion (qwen2.5-7b NPU) ==="
$body = @{
    model = "qwen2.5-7b-instruct-qnn-npu:3"
    messages = @(@{role="user"; content="Say hello in 5 words"})
    max_tokens = 50
} | ConvertTo-Json

try {
    $r = Invoke-WebRequest -Uri 'http://127.0.0.1:5272/v1/chat/completions' -Method POST -ContentType 'application/json; charset=utf-8' -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) -TimeoutSec 120
    Write-Output "Status: $($r.StatusCode)"
    $r.Content
} catch {
    Write-Output "HIBA: $($_.Exception.Message)"
}
