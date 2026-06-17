# Futtato processzek a C:\AI mappaban
Get-Process | Where-Object {$_.Path -like 'C:\AI\*'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, Path | Format-Table -AutoSize -Wrap
