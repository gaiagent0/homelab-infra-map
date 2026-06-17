# Foundry Local cache feltoltese D: meghajtón lévő modellekkel
$foundryCache = "C:\Users\istva\AppData\Local\Packages\Microsoft.FoundryLocal_8wekyb3d8bbwe\LocalCache\Local\Microsoft\FoundryLocal"
$modelsSource = "D:\models\Foundry\Microsoft"

Write-Output "=== Foundry Cache: $foundryCache ==="
if (-not (Test-Path $foundryCache)) {
    New-Item -ItemType Directory -Path $foundryCache -Force | Out-Null
}

# Modellek listaja
$modelDirs = @(
    "deepseek-r1-distill-qwen-7b-qnn-npu-2",
    "qwen2.5-1.5b-instruct-qnn-npu-2",
    "qwen2.5-7b-instruct-qnn-npu-2"
)

foreach ($modelName in $modelDirs) {
    $sourceV2 = Join-Path $modelsSource "$modelName\v2"
    $targetV2 = Join-Path $foundryCache "$modelName\v2"
    
    if (Test-Path $sourceV2) {
        if (-not (Test-Path $targetV2)) {
            Write-Output "Masolas: $modelName"
            Copy-Item -Path $sourceV2 -Destination $targetV2 -Recurse -Force
            $size = (Get-ChildItem $targetV2 -Recurse -File | Measure-Object -Property Length -Sum).Sum
            Write-Output "  KESZ: $([math]::Round($size/1GB,2)) GB"
        } else {
            Write-Output "Mar letezik: $modelName"
        }
    } else {
        Write-Output "HIANYOZIK: $sourceV2"
    }
}

# foundry.modelinfo.json masolasa
$modelInfoSource = "D:\models\Foundry\foundry.modelinfo.json"
$modelInfoTarget = Join-Path $foundryCache "foundry.modelinfo.json"
if (Test-Path $modelInfoSource) {
    Copy-Item -Path $modelInfoSource -Destination $modelInfoTarget -Force
    Write-Output "`nfoundry.modelinfo.json masolva"
}

Write-Output "`n=== Foundry cache tartalom ==="
Get-ChildItem $foundryCache -Recurse -File | Where-Object {$_.Length -gt 1MB} | Select-Object @{N='File';E={$_.FullName.Replace($foundryCache,'')}}, @{N='SizeMB';E={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
