# Foundry Local cache feltoltese D: meghajtón lévő modellekkel
$foundryCache = "C:\Users\istva\AppData\Local\Packages\Microsoft.FoundryLocal_8wekyb3d8bbwe\LocalCache\Local\Microsoft\FoundryLocal"
$modelsSource = "D:\models\Foundry\Microsoft"

Write-Output "=== Foundry Cache mappa ==="
if (Test-Path $foundryCache) {
    Write-Output "LETEZIK: $foundryCache"
    Get-ChildItem $foundryCache -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
} else {
    Write-Output "NEM LETEZIK: $foundryCache"
    New-Item -ItemType Directory -Path $foundryCache -Force | Out-Null
    Write-Output "Letrehozva: $foundryCache"
}

Write-Output "`n=== D:\models\Foundry\Microsoft modellek ==="
$modelDirs = Get-ChildItem $modelsSource -Directory
foreach ($dir in $modelDirs) {
    $v2Dir = Join-Path $dir.FullName "v2"
    if (Test-Path $v2Dir) {
        $totalSize = (Get-ChildItem $v2Dir -Recurse -File | Measure-Object -Property Length -Sum).Sum
        Write-Output "$($dir.Name): $([math]::Round($totalSize/1GB,2)) GB"
    }
}

Write-Output "`n=== Masolas a Foundry cache-be ==="
foreach ($dir in $modelDirs) {
    $v2Dir = Join-Path $dir.FullName "v2"
    if (Test-Path $v2Dir) {
        $targetDir = Join-Path $foundryCache $dir.Name
        if (-not (Test-Path $targetDir)) {
            Write-Output "Masolas: $($dir.Name) -> $targetDir"
            Copy-Item -Path $v2Dir -Destination $targetDir -Recurse -Force
            Write-Output "  KESZ: $([math]::Round((Get-ChildItem $targetDir -Recurse -File | Measure-Object -Property Length -Sum).Sum/1GB,2)) GB"
        } else {
            Write-Output "Mar letezik: $targetDir"
        }
    }
}

Write-Output "`n=== Foundry cache tartalom utana ==="
Get-ChildItem $foundryCache -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
