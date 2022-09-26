## Clean up Power BI settings
  WriteLog "Cleaning up Power BI settings" -ForegroundColor Yellow
  Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''"  | Out-File -FilePath $Logfile
  $mainprogressbaroverlay.PerformStep()
