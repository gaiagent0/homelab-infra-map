Write-Output "=== WindowsApps FoundryLocal ==="
Get-ChildItem "C:\Program Files\WindowsApps" -Filter "*Foundry*" 2>&1 | Select-Object Name

Write-Output "`n=== Packages FoundryLocal ==="
Get-ChildItem "$env:LOCALAPPDATA\Packages" -Filter "*Foundry*" 2>&1 | Select-Object Name

Write-Output "`n=== C:\AI nagy fajlok (>100MB) ==="
Get-ChildItem 'C:\AI' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Length -gt 100MB} | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
