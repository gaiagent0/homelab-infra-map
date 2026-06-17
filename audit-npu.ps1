# NPU ellenorzese
Write-Output "=== NPU Status ==="
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List

Write-Output "`n=== Foundry mappa ==="
Get-ChildItem 'C:\AI\apps\Foundry' -Recurse -File | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize

Write-Output "`n=== GenieAPI mappa ==="
Get-ChildItem 'C:\AI\apps\GenieAPIService_cpp' -Recurse -File | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize

Write-Output "`n=== Genie Chat mappa ==="
Get-ChildItem 'C:\AI\apps\genie-chat' -Recurse -File | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize

Write-Output "`n=== start-foundry.ps1 tartalom ==="
Get-Content 'C:\AI\apps\Foundry\start-foundry.ps1' 2>&1

Write-Output "`n=== genie-chat.bat tartalom ==="
Get-Content 'C:\AI\apps\genie-chat\genie-chat.bat' 2>&1
