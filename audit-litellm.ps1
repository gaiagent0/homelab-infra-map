# LiteLLM process es fajlok ellenorzese
Write-Output "=== LiteLLM processzek ==="
Get-Process | Where-Object {$_.ProcessName -match 'python|uvicorn|litellm'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, Path | Format-Table -AutoSize

Write-Output "`n=== LiteLLM config fajlok ==="
Get-ChildItem 'C:\AI\apps\litellm-win' -Recurse -File | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
