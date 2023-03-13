$DBs = @("AxDB", "DYNAMICSXREFDB", "AxDW", "DynamicsAxReportServer", "DynamicsAxReportServerTempDB", "FinancialReportingDb")
	
foreach ($DB in $DBs)
{
  Write-host -ForegroundColor Yellow "Shrink" $DB "Log File "(Get-Date).toString("yyyy-MM-dd hh:mm:ss")
  Invoke-DbaDbShrink -SqlInstance . -Database $DB -FileType Log -Verbose
  Expand-DbaDbLogFile -SqlInstance . -Database $DB -TargetLogSize 100 -IncrementSize 10 -ShrinkLogFile -ShrinkSize 10 -Verbose
  Write-host -ForegroundColor Green "Shrink" $DB "Log File "(Get-Date).toString("yyyy-MM-dd hh:mm:ss")
}
