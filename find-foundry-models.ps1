Write-Output "=== 1. Program Files\FoundryLocal ==="
$pf = "C:\Program Files\FoundryLocal"
if (Test-Path $pf) {
    Get-ChildItem $pf -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== 2. AppData\Local\FoundryLocal ==="
$local = "$env:LOCALAPPDATA\FoundryLocal"
if (Test-Path $local) {
    Get-ChildItem $local -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== 3. AppData\Local\Microsoft\FoundryLocal ==="
$ms = "$env:LOCALAPPDATA\Microsoft\FoundryLocal"
if (Test-Path $ms) {
    Get-ChildItem $ms -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== 4. ProgramData\FoundryLocal ==="
$pd = "C:\ProgramData\FoundryLocal"
if (Test-Path $pd) {
    Get-ChildItem $pd -Recurse -File | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize -Wrap
} else {
    Write-Output "NEM LETEZIK"
}

Write-Output "`n=== 5. foundry.exe helye ==="
Get-Command foundry -ErrorAction SilentlyContinue | Select-Object Source
