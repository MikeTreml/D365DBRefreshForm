## Clean up Power BI settings
  WriteLog "Cleaning up Power BI settings" -ForegroundColor Yellow
  #Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''" 
  Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''"
  $mainprogressbaroverlay.PerformStep()
