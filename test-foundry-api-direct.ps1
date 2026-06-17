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

Write-Output "`n=== 3. Models API ==="
try {
    $r = Invoke-WebRequest -Uri 'http://127.0.0.1:5272/v1/models' -TimeoutSec 10
    Write-Output "Status: $($r.StatusCode)"
    Write-Output $r.Content.Substring(0, [Math]::Min(1000, $r.Content.Length))
} catch {
    Write-Output "HIBA: $($_.Exception.Message)"
}

Write-Output "`n=== 4. Chat completion teszt ==="
$body = @{
    model = "qwen2.5-7b-instruct-qnn-npu:1"
    messages = @(@{role="user"; content="Say hello in 5 words"})
    max_tokens = 50
} | ConvertTo-Json

try {
    $r = Invoke-WebRequest -Uri 'http://127.0.0.1:5272/v1/chat/completions' -Method POST -ContentType 'application/json' -Body $body -TimeoutSec 60
    Write-Output "Status: $($r.StatusCode)"
    Write-Output $r.Content.Substring(0, [Math]::Min(500, $r.Content.Length))
} catch {
    Write-Output "HIBA: $($_.Exception.Message)"
}
