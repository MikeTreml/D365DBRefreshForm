 ## Put on hold all Batch Jobs
  Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)  --Set any waiting, executing, ready, or canceling batches to withhold."
  #Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7) | Out-File -FilePath $Logfile

