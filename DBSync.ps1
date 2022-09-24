 ## Run Database Sync
  WriteLog "Executing Database Sync" -ForegroundColor Yellow
  Invoke-D365DBSync -ShowOriginalProgress -Verbose
  $mainprogressbaroverlay.PerformStep()
