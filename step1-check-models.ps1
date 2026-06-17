Write-Output "=== genie_bundle tartalom ==="
Get-ChildItem 'C:\AI\genie_bundle' | Select-Object Name | Format-Table -AutoSize

Write-Output "`n=== Qwen2.5-7B fajlok ==="
Get-ChildItem 'C:\AI\genie_bundle\Qwen2.5-7B' -Recurse -File | Select-Object @{N='File';E={$_.Name}}, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
