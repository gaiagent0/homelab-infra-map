Write-Output "=== 1. WindowsApps FoundryLocal ==="
$wa = "C:\Program Files\WindowsApps\FoundryLocal*"
Get-ChildItem $wa -ErrorAction SilentlyContinue | Select-Object Name

Write-Output "`n=== 2. Package cache ==="
$pkg = "$env:LOCALAPPDATA\Packages\FoundryLocal*"
Get-ChildItem $pkg -ErrorAction SilentlyContinue | Select-Object Name

Write-Output "`n=== 3. LocalCache modell fajlok ==="
$lc = "$env:LOCALAPPDATA\Packages"
Get-ChildItem $lc -Filter "*Foundry*" -ErrorAction SilentlyContinue | ForEach-Object {
    Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Length -gt 1MB} | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
}

Write-Output "`n=== 4. Modell fajlok keresese (2GB+) ==="
Get-ChildItem 'C:\' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Length -gt 2GB} | Select-Object FullName, @{N='SizeGB';E={[math]::Round($_.Length/1GB,1)}} | Format-Table -AutoSize -Wrap
