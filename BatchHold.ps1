$Stamp = (Get-Date).toString("yyyy-MM-dd")

## Put on hold all Batch Jobs
Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)"
