Write-Output "=== C:\AI\npu\models tartalom ==="
Get-ChildItem 'C:\AI\npu\models' -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap

Write-Output "`n=== C:\AI\npu teljes struktura ==="
Get-ChildItem 'C:\AI\npu' -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
