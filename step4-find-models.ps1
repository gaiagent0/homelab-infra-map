Write-Output "=== serialized.bin fajlok keresese ==="
Get-ChildItem 'C:\' -Recurse -Filter '*.serialized.bin' -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
