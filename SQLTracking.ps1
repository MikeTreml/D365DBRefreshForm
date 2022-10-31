$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp\SQLTracking.txt"
Start-Transcript -Path $LogFile -Append -Force

## Enable SQL Change Tracking
Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)" | Out-File -FilePath $Logfile

Stop-Transcript 
