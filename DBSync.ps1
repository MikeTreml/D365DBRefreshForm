$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp.txt"
Start-Transcript -Path $LogFile -Append -Force

## Run Database Sync
Invoke-D365DBSync -ShowOriginalProgress -Verbose

Stop-Transcript
