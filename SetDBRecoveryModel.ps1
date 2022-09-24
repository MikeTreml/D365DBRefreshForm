## Set DB Recovery Model to Simple  (Optional)
  WriteLog "Setting DB Recovery Model to Simple" -ForegroundColor Yellow
  Set-DbaDbRecoveryModel -Verbose -SqlInstance localhost -RecoveryModel Simple -Database AxDB -Confirm:$false
  $mainprogressbaroverlay.PerformStep()
