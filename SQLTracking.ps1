 ## Enable SQL Change Tracking
  WriteLog "Enabling SQL Change Tracking" -ForegroundColor Yellow
  #Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)" 
  Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)"
  $mainprogressbaroverlay.PerformStep()
