Write-Output "=== D: meghajtó struktura ==="
Get-ChildItem 'D:\' | Select-Object Name, PSIsContainer | Format-Table -AutoSize

Write-Output "`n=== D: nagy fajlok (>100MB) ==="
Get-ChildItem 'D:\' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Length -gt 100MB} | Select-Object FullName, @{N='SizeGB';E={[math]::Round($_.Length/1GB,2)}} | Format-Table -AutoSize -Wrap

Write-Output "`n=== D: modell fajlok (.gguf, .onnx, .bin, .safetensors) ==="
Get-ChildItem 'D:\' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Extension -match '\.gguf$|\.onnx$|\.safetensors$|\.bin$'} | Select-Object FullName, @{N='SizeGB';E={[math]::Round($_.Length/1GB,2)}} | Format-Table -AutoSize -Wrap
