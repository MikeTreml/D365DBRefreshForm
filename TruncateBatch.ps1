$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
Start-Transcript -Path $LogFile -Append -IncludeInvocationHeader

Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "TRUNCATE TABLE SYSSERVERCONFIG
TRUNCATE TABLE SYSSERVERSESSIONS
TRUNCATE TABLE SYSCORPNETPRINTERS
TRUNCATE TABLE SYSCLIENTSESSIONS
TRUNCATE TABLE BATCHSERVERCONFIG
TRUNCATE TABLE BATCHSERVERGROUP
TRUNCATE TABLE BatchHistory
TRUNCATE TABLE BatchJobHistory
TRUNCATE TABLE DMFSTAGINGVALIDATIONLOG
TRUNCATE TABLE DMFSTAGINGEXECUTIONERRORS
TRUNCATE TABLE DMFSTAGINGLOGDETAIL
TRUNCATE TABLE DMFSTAGINGLOG 
TRUNCATE TABLE DMFDEFINITIONGROUPEXECUTIONHISTORY
TRUNCATE TABLE DMFEXECUTION
TRUNCATE TABLE DMFDEFINITIONGROUPEXECUTION" 

Stop-Transcript 
