$ErrorActionPreference = 'Inquire'

$buttonDBDelete.Visible =$false
$mainprogressbaroverlay.Maximum = 12
$mainprogressbaroverlay.Step = 1
$mainprogressbaroverlay.Value = 0
$mainprogressbaroverlay.Visible = $True
count-checkbox
[string]$dt = get-date -Format "yyyyMMdd_hh_mm" #Generate the datetime stamp to make DB files unique

WriteLog $oldFile = Get-Item G:\MSSQL_DATA\AxDB*Primary.mdf -Verbose
$renameOldFile = $('G:\MSSQL_DATA\AxDB_PrimaryOld_') + $dt + $('.mdf')
WriteLog $oldFile -ForegroundColor Yellow
WriteLog $renameOldFile -ForegroundColor Yellow
Start-Sleep -Seconds 3;
Install-D365foDbatools 
$NewDB = $('AxDB')+ $dt #Database name. No spaces in the name!

if ($txtLink.Text -ne '')
{
	#If you are going to download BACPAC file from the LCS Asset Library, please use in this section
	$BacpacSasLinkFromLCS = $txtLink.Text

	$TempFolder = 'd:\temp\' # 'c:\temp\'  #$env:TEMP
	#region Download bacpac from LCS
	if ($BacpacSasLinkFromLCS.StartsWith('http'))
	{
		WriteLog "Downloading BACPAC from the LCS Asset library" -ForegroundColor Yellow
		New-Item -Path $TempFolder -ItemType Directory -Force -Verbose
		$TempFileName = Join-path $TempFolder -ChildPath "$NewDB.bacpac"

		WriteLog "..Downloading file" $TempFileName -ForegroundColor Yellow

		Invoke-D365InstallAzCopy -Verbose
		Invoke-D365AzCopyTransfer -SourceUri $BacpacSasLinkFromLCS -DestinationUri $TempFileName -ShowOriginalProgress -Verbose

		$f = Get-ChildItem $TempFileName
		$NewDB = $($f.BaseName).Replace(' ', '_')
	}
}
elseif ($txtFile.Text -ne '')
{
	$f = Get-ChildItem $txtFile.Text #Please note that this file should be accessible from SQL server service account
	$FileDB = $TempFolder + $NewDB
	Move-Item -Path $txtFile.Text -Destination $FileDB
}
if ($checkboxTruncateBatchTables.Checked)
{
	#WriteLog "..Tuncate" $NewDB
	#Clear-D365BacpacTableData -Path $NewDB -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY","SYSSERVERCONFIG","SYSSERVERSESSIONS","SYSCORPNETPRINTERS","SYSCLIENTSESSIONS","BATCHSERVERCONFIG","BATCHSERVERGROUP" -ClearFromSource -Verbose
	#WriteLog "Done Tuncate" $NewDB
}
$mainprogressbaroverlay.PerformStep()

## Stop D365FO instance.
WriteLog "Stopping D365FO environment" -ForegroundColor Yellow

Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Enable-D365Exception"
Enable-D365Exception
$mainprogressbaroverlay.PerformStep()
#WriteLog "Start SQLbar"
#Start-Job -ScriptBlock { Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/pbar.ps1) }
#WriteLog "SQL bar"
#start-sleep -seconds 10
WriteLog "Installing modern SqlPackage"
Invoke-D365InstallSqlPackage #Installing modern SqlPackage just in case  
$mainprogressbaroverlay.PerformStep()
## Import bacpac to SQL Database
WriteLog "Checking SQL file" $f.FullName
WriteLog $f
If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName)))
{
	WriteLog  "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
	throw "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
}
$mainprogressbaroverlay.PerformStep()
WriteLog "Unblock-File"
$f | Unblock-File

WriteLog "Import BACPAC file to the SQL database" $NewDB -ForegroundColor Yellow

$mainprogressbaroverlay.PerformStep()
WriteLog "Import-D365Bacpac"
Import-D365Bacpac -ImportModeTier1 -BacpacFile $f.FullName -NewDatabaseName $NewDB -ShowOriginalProgress

## Removing AxDB_orig database and Switching AxDB:   NULL <-1- AxDB_original <-2- AxDB <-3- [NewDB]
WriteLog "Stopping D365FO environment and Switching Databases" -ForegroundColor Yellow
Stop-D365Environment -All -Kill -Verbose
WriteLog "Switch-D365ActiveDatabase"
if(Get-D365Database -Name AXDB)
{
	WriteLog "switch DB"
	Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose
	WriteLog "switch DB done"
	$mainprogressbaroverlay.PerformStep()
	#WriteLog "Remove-D365Database"
	#$decision = $Host.UI.PromptForChoice('something', 'Do you wish to delete old database or keep', ('&Delete', '&Keep'), 1)
	#if ($decision -eq 0) 
	#{
		WriteLog "Stop-D365Environment"
		Stop-D365Environment -All -Kill -Verbose
		$buttonDBDelete.Visible =$true
		#WriteLog "Start remove DB"
		#Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
		#WriteLog "removed DB"
		$mainprogressbaroverlay.PerformStep()
	#} 
	#else 
	#{
		#move the file
		#$mainprogressbaroverlay.PerformStep()
		#WriteLog "Stop-Service MSSQLSERVER, SQLSERVERAGENT"
		#Stop-Service MSSQLSERVER, SQLSERVERAGENT -Force -Verbose

		#[string]$dt = get-date -Format "yyyyMMdd"
		#$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
		#[string]$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf' -Exclude AxDB*$dt*Primary.mdf
		#if ($oldFile -ne '')
		#{
			#WriteLog "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
			#Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_$dt.mdf
		#}
		#WriteLog "Start-Service MSSQLSERVER, SQLSERVERAGENT "
		#Start-Service MSSQLSERVER, SQLSERVERAGENT -Verbose
	#}
	## Start D365FO instance
	WriteLog "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow
	Start-D365Environment
	$mainprogressbaroverlay.PerformStep()
}
else
{	
	Write-Host "is not standard names"
}
if ($checkboxBackupNewlyCompleted.Checked)
{
	WriteLog "Backup AxDB" -ForegroundColor Yellow
	$labelInfo = ""
	Invoke-DbaQuery -Verbose -SqlInstance localhost -Database AxDB -Type Full -CompressBackup -BackupFileName "dbname-$NewDB-backuptype-timestamp.bak" -ReplaceInName
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxCleanUpPowerBISettin.Checked)
{
	## Clean up Power BI settings
	WriteLog "Cleaning up Power BI settings" -ForegroundColor Yellow
	#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''" 
	Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''"
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxEnableSQLChangeTrack.Checked)
{
	## Enable SQL Change Tracking
	WriteLog "Enabling SQL Change Tracking" -ForegroundColor Yellow
	#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)" 
	Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)"
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxPromoteNewAdmin.Checked)
{
	## Promote user as admin and set default tenant  (Optional)
	WriteLog "Setting up new Admin" -ForegroundColor Yellow
	Set-D365Admin -Verbose -AdminSignInName textboxAdminEmailAddress.Text
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxTruncateBatchTables.Checked)
{
	WriteLog "Truncate Batch Tables"
	Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "
	TRUNCATE TABLE SYSSERVERCONFIG
	TRUNCATE TABLE SYSSERVERSESSIONS
	TRUNCATE TABLE SYSCORPNETPRINTERS
	TRUNCATE TABLE SYSCLIENTSESSIONS
	TRUNCATE TABLE BATCHSERVERCONFIG
	TRUNCATE TABLE BATCHSERVERGROUP"
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxPutAllBatchJobsOnHol.Checked)
{
	## Put on hold all Batch Jobs
	WriteLog "Disabling all current Batch Jobs" -ForegroundColor Yellow
	#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)  --Set any waiting, executing, ready, or canceling batches to withhold."
	Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)  --Set any waiting, executing, ready, or canceling batches to withhold."
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxRunDatabaseSync.Checked)
{
	## Run Database Sync
	WriteLog "Executing Database Sync" -ForegroundColor Yellow
	Invoke-D365DBSync -ShowOriginalProgress -Verbose
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxSetDBRecoveryModel.Checked)
{
	## Set DB Recovery Model to Simple  (Optional)
	WriteLog "Setting DB Recovery Model to Simple" -ForegroundColor Yellow
	Set-DbaDbRecoveryModel -Verbose -SqlInstance localhost -RecoveryModel Simple -Database AxDB -Confirm:$false
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxEnableUsersExceptGue.Checked)
{
	## Enable Users except Guest
	WriteLog "Enable all users except Guest" -ForegroundColor Yellow
	#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "Update USERINFO set ENABLE = 1 where ID != 'Guest'"
	Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "Update USERINFO set ENABLE = 1 where ID != 'Guest'"
	Enable-D365User -Email "*@*.com" -Verbose
	Update-D365User -Email "*@*.com" -Verbose
	$mainprogressbaroverlay.PerformStep()
}

if ($checkboxListOutUserEmails.Checked)
{
	WriteLog "List Out User Email Addresses" -ForegroundColor Yellow
	#Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "
	#select ID, Name, NetworkAlias, NETWORKDOMAIN, Enable from userInfo
	#where NETWORKALIAS not like '%@contosoax7.onmicrosoft.com'
	#and NETWORKALIAS not like '%@capintegration01.onmicrosoft.com'
	#and NETWORKALIAS not like '%@devtesttie.ccsctp.net'
	#and NETWORKALIAS not like '%@DAXMDSRunner.com'
	#and NETWORKALIAS not like '%@dynamics.com'
	#and NETWORKALIAS != ''"
	$mainprogressbaroverlay.PerformStep()
}
