#region Install and run Ola Hallengren's IndexOptimize
	
	Function Execute-Sql
	{
		Param (
			[Parameter(Mandatory = $true)]
			[string]$server,
			[Parameter(Mandatory = $true)]
			[string]$database,
			[Parameter(Mandatory = $true)]
			[string]$command
		)
		Process
		{
			$scon = New-Object System.Data.SqlClient.SqlConnection
			$scon.ConnectionString = "Data Source=$server;Initial Catalog=$database;Integrated Security=true"
			
			$cmd = New-Object System.Data.SqlClient.SqlCommand
			$cmd.Connection = $scon
			$cmd.CommandTimeout = 0
			$cmd.CommandText = $command
			
			try
			{
				$scon.Open()
				$cmd.ExecuteNonQuery()
			}
			catch [Exception] {
				Write-Warning $_.Exception.Message
			}
			finally
			{
				$scon.Dispose()
				$cmd.Dispose()
			}
		}
	}
	
	If (Test-Path "HKLM:\Software\Microsoft\Microsoft SQL Server\Instance Names\SQL")
	{
		
		Write-Host "Installing dbatools PowerShell module"
		Install-Module -Name dbatools -SkipPublisherCheck -Scope AllUsers
		
		Import-Module dbatools
		
		Set-DbaMaxMemory -SqlInstance . -Max 4096
		
		Write-Host "Installing Ola Hallengren's SQL Maintenance scripts"
		Import-Module -Name dbatools
		Install-DbaMaintenanceSolution -SqlInstance . -Database master
		
		Write-Host "Installing FirstAidResponder PowerShell module"
		Install-DbaFirstResponderKit -SqlInstance . -Database master
		
		Write-Host "Install latest CU"
		$PathExists = Test-Path("C:\temp\SqlKB")
		if ($PathExists -eq $false)
		{
			mkdir "C:\temp\SqlKB"
		}
		
		$DownloadPath = "C:\temp\SqlKB"
		
		$BuildTargets = Test-DbaBuild -SqlInstance . -MaxBehind 0CU -Update | Where-Object { !$PSItem.Compliant } | Select-Object -ExpandProperty BuildTarget -Unique
		Get-DbaBuildReference -Build $BuildTargets | ForEach-Object { Save-DbaKBUpdate -Path $DownloadPath -Name $PSItem.KBLevel };
		Update-DbaInstance -ComputerName . -Path $DownloadPath -Confirm:$false
		
		$BuildTargets = Test-DbaBuild -SqlInstance . -MaxBehind 0CU -Update | Where-Object { !$PSItem.Compliant } | Select-Object -ExpandProperty BuildTarget -Unique
		Get-DbaBuildReference -Build $BuildTargets | ForEach-Object { Save-DbaKBUpdate -Path $DownloadPath -Name $PSItem.KBLevel };
		Update-DbaInstance -ComputerName . -Path $DownloadPath -Confirm:$false
		
		Write-Host "Adding trace flags"
		Enable-DbaTraceFlag -SqlInstance . -TraceFlag 174, 834, 1204, 1222, 1224, 2505, 7412
		
		Write-Host "Restarting service"
		Restart-DbaService -Type Engine -Force
		
		Write-Host "Setting recovery model"
		Set-DbaDbRecoveryModel -SqlInstance . -RecoveryModel Simple -Database AxDB -Confirm:$false
		
		Write-Host "Setting database options"
		$sql = "ALTER DATABASE [AxDB] SET AUTO_CLOSE OFF"
		Execute-Sql -server "." -database "AxDB" -command $sql
		
		$sql = "ALTER DATABASE [AxDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF"
		Execute-Sql -server "." -database "AxDB" -command $sql
		
		Write-Host "Setting batchservergroup options"
		$sql = "delete batchservergroup where SERVERID <> 'Batch:'+@@servername
    insert into batchservergroup(GROUPID, SERVERID, RECID, RECVERSION, CREATEDDATETIME, CREATEDBY)
    select GROUP_, 'Batch:'+@@servername, 5900000000 + cast(CRYPT_GEN_RANDOM(4) as bigint), 1, GETUTCDATE(), '-admin-' from batchgroup
        where not EXISTS (select recid from batchservergroup where batchservergroup.GROUPID = batchgroup.GROUP_)"
		Execute-Sql -server "." -database "AxDB" -command $sql
		
		Write-Host "purging disposable data"
		$sql = "truncate table batchjobhistory
    truncate table batchhistory
    truncate table eventcud
    truncate table sysdatabaselog
    delete batchjob where status in (3, 4, 8)
    delete batch where not exists (select recid from batchjob where batch.BATCHJOBID = BATCHJOB.recid)
    EXEC sp_msforeachtable
    @command1 ='truncate table ?'
    ,@whereand = ' And Object_id In (Select Object_id From sys.objects
    Where name like ''%tmp'')'"
		
		Execute-Sql -server "." -database "AxDB" -command $sql
		
		Write-Host "purging staging tables data"
		$sql = "EXEC sp_msforeachtable
    @command1 ='truncate table ?'
    ,@whereand = ' And Object_id In (Select Object_id From sys.objects
    Where name like ''%staging'')'"
		
		Execute-Sql -server "." -database "AxDB" -command $sql
		
		Write-Host "purging disposable large tables data"
		$LargeTables | ForEach-Object {
			$sql = "delete $_ where $_.CREATEDDATETIME < dateadd(""MM"", -2, getdate())"
			Execute-Sql -server "." -database "AxDB" -command $sql
		}
		
		$sql = "DELETE [REFERENCES] FROM [REFERENCES]
    JOIN Names ON (Names.Id = [REFERENCES].SourceId OR Names.Id = [REFERENCES].TargetId)
    JOIN Modules ON Names.ModuleId = Modules.Id
    WHERE Module LIKE '%Test%' AND Module <> 'TestEssentials'"
		
		Execute-Sql -server "." -database "DYNAMICSXREFDB" -command $sql
		
		Write-Host "Reclaiming freed database space"
		Invoke-DbaDbShrink -SqlInstance . -Database "AxDb" -FileType Data
		Invoke-DbaDbShrink -SqlInstance . -Database "AxDb", "DYNAMICSXREFDB" -FileType Data
		
		Write-Host "Running Ola Hallengren's IndexOptimize tool"
		# http://calafell.me/defragment-indexes-on-d365-finance-operations-virtual-machine/
		$sql = "EXECUTE master.dbo.IndexOptimize
        @Databases = 'ALL_DATABASES',
        @FragmentationLow = NULL,
        @FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
        @FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
        @FragmentationLevel1 = 5,
        @FragmentationLevel2 = 25,
        @LogToTable = 'N',
        @UpdateStatistics = 'ALL',
        @OnlyModifiedStatistics = 'Y'"
		
		Execute-Sql -server "." -database "master" -command $sql
		
		Write-Host "Reclaiming database log space"
		Invoke-DbaDbShrink -SqlInstance . -Database "AxDb", "DYNAMICSXREFDB" -FileType Log -ShrinkMethod TruncateOnly
	}
	Else
	{
		Write-Verbose "SQL not installed.  Skipped Ola Hallengren's index optimization"
	}
	
	#endregion
