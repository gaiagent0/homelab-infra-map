# Foundry Local cache feltoltese + modelinfo frissites
$foundryCache = "C:\Users\istva\AppData\Local\Packages\Microsoft.FoundryLocal_8wekyb3d8bbwe\LocalCache\Local\Microsoft\FoundryLocal"
$modelsSource = "D:\models\Foundry\Microsoft"
$modelInfoSource = "D:\models\Foundry\foundry.modelinfo.json"

Write-Output "=== 1. Cache mappa ellenorzese ==="
if (-not (Test-Path $foundryCache)) {
    New-Item -ItemType Directory -Path $foundryCache -Force | Out-Null
    Write-Output "Letrehozva: $foundryCache"
} else {
    Write-Output "LETEZIK: $foundryCache"
}

Write-Output "`n=== 2. Modellek masolasa ==="
$modelDirs = @(
    "deepseek-r1-distill-qwen-7b-qnn-npu-2",
    "qwen2.5-1.5b-instruct-qnn-npu-2",
    "qwen2.5-7b-instruct-qnn-npu-2"
)

foreach ($modelName in $modelDirs) {
    $sourceV2 = Join-Path $modelsSource "$modelName\v2"
    $targetModel = Join-Path $foundryCache $modelName
    
    if (Test-Path $sourceV2) {
        if (-not (Test-Path $targetModel)) {
            Write-Output "Masolas: $modelName ..."
            Copy-Item -Path $sourceV2 -Destination "$targetModel\v2" -Recurse -Force
            $size = (Get-ChildItem $targetModel -Recurse -File | Measure-Object -Property Length -Sum).Sum
            Write-Output "  KESZ: $([math]::Round($size/1GB,2)) GB"
        } else {
            $size = (Get-ChildItem $targetModel -Recurse -File | Measure-Object -Property Length -Sum).Sum
            Write-Output "Mar letezik: $modelName ($([math]::Round($size/1GB,2)) GB)"
        }
    } else {
        Write-Output "HIANYOZIK: $sourceV2"
    }
}

Write-Output "`n=== 3. modelinfo frissites ==="
# A foundry.modelinfo.json-t at kell alakitani, hogy lokalis modelleket is támogasson
# Egyelore csak atmasoljuk a regit, es kesobb frissitjuk
if (Test-Path $modelInfoSource) {
    $modelInfoTarget = Join-Path $foundryCache "foundry.modelinfo.json"
    Copy-Item -Path $modelInfoSource -Destination $modelInfoTarget -Force
    Write-Output "foundry.modelinfo.json masolva"
}

Write-Output "`n=== 4. Cache tartalom ==="
Get-ChildItem $foundryCache -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object @{N='File';E={$_.FullName.Replace($foundryCache,'')}}, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize

Write-Output "`n=== 5. foundry model run teszt ==="
foundry service status 2>&1
