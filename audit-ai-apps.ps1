# AI apps audit - mappak es futtatott fajlok
$apps = Get-ChildItem 'C:\AI\apps' -Directory
foreach ($app in $apps) {
    $name = $app.Name
    $exe = Get-ChildItem $app.FullName -Recurse -Filter '*.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
    $bat = Get-ChildItem $app.FullName -Recurse -Filter '*.bat' -ErrorAction SilentlyContinue | Select-Object -First 1
    $ps1 = Get-ChildItem $app.FullName -Recurse -Filter '*.ps1' -ErrorAction SilentlyContinue | Select-Object -First 1
    $py = Get-ChildItem $app.FullName -Recurse -Filter '*.py' -ErrorAction SilentlyContinue | Select-Object -First 1
    $files = @()
    if ($exe) { $files += "EXE:$($exe.Name)" }
    if ($bat) { $files += "BAT:$($bat.Name)" }
    if ($ps1) { $files += "PS1:$($ps1.Name)" }
    if ($py) { $files += "PY:$($py.Name)" }
    $fileStr = ($files -join ', ')
    Write-Output "$name | $fileStr"
}
