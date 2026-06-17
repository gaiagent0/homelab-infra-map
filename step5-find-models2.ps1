Write-Output "=== C:\AI modell fajlok ==="
Get-ChildItem 'C:\AI' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Extension -match '\.bin$|\.gguf$|\.safetensors$|\.serialized$'} | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap

Write-Output "`n=== C:\models mappa ==="
if (Test-Path 'C:\models') {
    Get-ChildItem 'C:\models' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Extension -match '\.bin$|\.gguf$|\.safetensors$|\.serialized$'} | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== C:\AI\genie_bundle teljes tartalom ==="
Get-ChildItem 'C:\AI\genie_bundle' -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
