# Node folyamatok ellenorzese
Get-Process | Where-Object {$_.ProcessName -match 'node|python|uvicorn'} | Select-Object ProcessName, Id, @{N='MemMB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, Path | Format-Table -AutoSize -Wrap
