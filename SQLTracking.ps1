Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AdventureWorks2012 SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)"
