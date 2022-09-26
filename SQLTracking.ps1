 ## Enable SQL Change Tracking
  WriteLog "Enabling SQL Change Tracking" -ForegroundColor Yellow
  Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)" | Out-File -FilePath $Logfile

