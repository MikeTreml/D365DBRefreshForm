
$mainprogressbaroverlay.Maximum = 10
$mainprogressbaroverlay.Step = 1
$mainprogressbaroverlay.Value = 0
$mainprogressbaroverlay.Visible = $True

[string]$dt = get-date -Format "yyyyMMdd_hhmm" 
$NewDB = 'AxDB_'+$dt
count-checkbox

Write-host -ForegroundColor Yellow "Stopping D365FO environment "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
Stop-D365Environment -All -Kill -Verbose
#Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/D365tools.ps1)
Write-Host "Installing PowerShell modules d365fo.tools and dbatools "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") -ForegroundColor Yellow

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$modules2Install = @('d365fo.tools', 'dbatools')
foreach ($module in $modules2Install)
{
  Write-Host  "..working on module $module"
  if ($null -eq $(Get-Command -Module $module))
  {
    Write-Host  "....installing module $module" -ForegroundColor Gray
    Install-Module -Name $module -SkipPublisherCheck -Scope AllUsers -Verbose -force
  }
  else
  {
    Write-Host  "....updating module" $module -ForegroundColor Gray
    Update-Module -Name $module -Verbose -force
  }
  $mainprogressbaroverlay.PerformStep()
}
Write-Host "Done Installing PowerShell modules d365fo.tools and dbatools "(Get-Date).toString("yyyy-MM-dd hh:mm:ss")  -ForegroundColor Green

$mainprogressbaroverlay.PerformStep()
Write-host "Done Stopping D365FO environment "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 

Stop-D365Environment -All -Kill -Verbose

if ($txtLink.Text -ne ''){
	#If you are going to download BACPAC file from the LCS Asset Library, please use in this section
	$BacpacSasLinkFromLCS = $txtLink.Text
	
	$TempFolder = 'D:\temp\' # 'c:\temp\'  #$env:TEMP
	#region Download bacpac from LCS
	if ($BacpacSasLinkFromLCS.StartsWith('http'))	{
       		Write-host -ForegroundColor Yellow "Downloading BACPAC from the LCS Asset library  "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
		New-Item -Path $TempFolder -ItemType Directory -Force -Verbose
		$TempFileName = Join-path $TempFolder -ChildPath "$NewDB.bacpac"
		$TempFileName2 = Join-path $TempFolder -ChildPath "$NewDB Temp.bacpac"
        	Write-host -ForegroundColor Yellow "..Downloading file" $TempFileName

		Invoke-D365InstallAzCopy -Verbose
		Invoke-D365AzCopyTransfer -SourceUri $BacpacSasLinkFromLCS -DestinationUri $TempFileName2 -ShowOriginalProgress -Verbose
		Write-host -ForegroundColor Green "Done ..Downloading file" $TempFileName2
		Clear-D365BacpacTableData -Path $TempFileName2 -Table "BATCHJOBHISTORY","DOCUHISTORY" -OutputPath $TempFileName
		$f = Get-ChildItem $TempFileName
		$NewDB = $($f.BaseName).Replace(' ', '_')
	}
}
elseif ($txtFile.Text -ne ''){
	$f = Get-ChildItem $txtFile.Text #Please note that this file should be accessible from SQL server service account
	$NewDB = $($f.BaseName).Replace(' ', '_') + $('_') + $dt; #'AxDB_CTS1005BU2'  #Temporary Database name for new AxDB. Use a file name or any meaningful name.
}
$mainprogressbaroverlay.PerformStep()

Write-host -ForegroundColor Yellow "Stopping D365FO environment "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Stopping D365FO environment "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 

Write-host -ForegroundColor Yellow "Enable-D365Exception "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
Enable-D365Exception -Verbose
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Enable-D365Exception "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 

Write-host -ForegroundColor Yellow "Installing modern SqlPackage "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
Invoke-D365InstallSqlPackage -Verbose 
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Installing modern SqlPackage "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 

Write-host -ForegroundColor Yellow "Checking SQL file "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName))){
	Write-Warning "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
	throw "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
}
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Checking SQL file "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 

Write-host -ForegroundColor Yellow "Unblock-File "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
$f | Unblock-File
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Unblock-File "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 

Write-host -ForegroundColor Yellow "Import-D365Bacpac "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
Import-D365Bacpac -ImportModeTier1 -BacpacFile $f.FullName -NewDatabaseName $NewDB -ShowOriginalProgress
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Import-D365Bacpac "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 



if(Get-SqlDatabase -ServerInstance localhost -Name "AxDB"){
	Write-host -ForegroundColor Yellow "Switch-D365ActiveDatabase "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	Stop-D365Environment -All -Kill -Verbose
	Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose
	Write-host -ForegroundColor Green "Done Switch-D365ActiveDatabase "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}
else{
	Write-host -ForegroundColor Yellow "set-D365ActiveDatabase "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	Invoke-DbaQuery -SqlInstance localhost -Database master -Query "ALTER DATABASE '$NewDB' SET SINGLE_USER WITH ROLLBACK IMMEDIATE ALTER DATABASE '$NewDB' MODIFY NAME = AxDB ALTER DATABASE AxDB SET MULTI_USER ALTER DATABASE AxDB SET AUTO_CLOSE OFF WITH NO_WAIT"
	Write-host -ForegroundColor Green "Done set-D365ActiveDatabase "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}
$mainprogressbaroverlay.PerformStep()

if ($checkbox2.Checked){

	Write-host -ForegroundColor Yellow "Starting 2 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/2)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 2 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkbox3.Checked){

	Write-host -ForegroundColor Yellow "Starting 3 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/3)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 3 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkbox4.Checked){

	Write-host -ForegroundColor Yellow "Starting 4 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/4)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 4 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkbox5.Checked){

	Write-host -ForegroundColor Yellow "Starting 5 "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/5)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 5  "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxBackupNewlyCompleted.Checked){

	Write-host -ForegroundColor Yellow "Starting Backup AxDB "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BackUpDB.ps1)
	$labelInfo = ""
	Invoke-DbaQuery -Verbose -SqlInstance localhost -Database AxDB -Type Full -CompressBackup -BackupFileName "dbname-$NewDB-backuptype-timestamp.bak" -ReplaceInName | Out-File -FilePath $Logfile
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Backup AxDB "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxCleanUpPowerBI.Checked){

	Write-host -ForegroundColor Yellow "Starting Cleaning up Power BI settings "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
	## Clean up Power BI settings
	Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''"  | Out-File -FilePath $Logfile
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Cleaning up Power BI settings "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxEnableSQLTracking.Checked){

	Write-host -ForegroundColor Yellow "Starting SQL Tracking "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SQLTracking.ps1)
	## Enable SQL Change Tracking
	Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)" | Out-File -FilePath $Logfile
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done SQL Tracking "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxPromoteNewAdmin.Checked){

	Write-host -ForegroundColor Yellow "Starting New Admin "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/NewAdmin.ps1)
	## Promote user as admin and set default tenant  (Optional)
	Set-D365Admin -Verbose -AdminSignInName textboxAdminEmailAddress.Text
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done New Admin "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxTruncateBatchTables.Checked){

	Write-host -ForegroundColor Yellow "Starting truncate Batch "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
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

	Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "declare @t table 
	(id bigint identity(1,1), sqlQuery nvarchar(500))
	declare @maxid bigint, @i	bigint, @sqlquery nvarchar(500)
	insert into @t (sqlQuery)
	select ' truncate table ' + name from sysobjects where name like '%staging'
	select @maxid = MAX(id) from @t
	set @i=1
	while (@i<=@maxid)
	BEGIN
	select @sqlquery = sqlQuery from @t where id = @i
	exec(@sqlQuery)
	set @i=@i+1
	END"
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done truncate Batch "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxPauseBatchJobs.Checked){

	Write-host -ForegroundColor Yellow "Starting hold batch jobs "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
	## Put on hold all Batch Jobs
	Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)  --Set any waiting, executing, ready, or canceling batches to withhold."
	#Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7) | Out-File -FilePath $Logfile
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done hold batch jobs "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxEnableUsers.Checked){

	Write-host -ForegroundColor Yellow "Starting Enable Users "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/EnableUsers.ps1)
	Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES ('aniela','aniela',1,'','https://sts.windows.net/caf2code.com/','aniela@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('mike','mike',1,'','https://sts.windows.net/caf2code.com/','mike@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('benbreeden','benbreeden',1,'','https://sts.windows.net/caf2code.com/','benbreeden@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('Brittany','Brittany',1,'','https://sts.windows.net/caf2code.com/','Brittany@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('d.ki21','d.ki21',1,'','https://sts.windows.net/caf2code.com/','d.ki21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('L.FL21','L.FL21',1,'','https://sts.windows.net/caf2code.com/','L.FL21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('laurenwooll','laurenwooll',1,'','https://sts.windows.net/caf2code.com/','laurenwooll@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('m.ri21','m.ri21',1,'','https://sts.windows.net/caf2code.com/','m.ri21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('mac','mac',1,'','https://sts.windows.net/caf2code.com/','mac@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('r.qu21','r.qu21',1,'','https://sts.windows.net/caf2code.com/','r.qu21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('aniela','aniela',1,'','https://sts.windows.net/caf2code.com/','aniela@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
	VALUES	('justin','justin',1,'','https://sts.windows.net/caf2code.com/','justin@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('mike', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('benbreeden', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('Brittany', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('d.ki21', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('L.FL21', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('laurenwooll', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('m.ri21', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('mac', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('r.qu21', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('justin', 2, 1, 1, 0, 0)
	insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('aniela', 2, 1, 1, 0, 0)
	UPDATE [dbo].[USERINFO] SET [COMPANY] = 'PQI' WHERE NETWORKALIAS like '%caf2code.com'
	Update USERINFO set ENABLE = 1 where ID != 'Guest'"

	Enable-D365User -Email "*caf2code*"
	update-D365User -Email "*caf2code*"

	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Enable Users "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxRunDatabaseSync.Checked){

	Write-host -ForegroundColor Yellow "Starting DB sync "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
	## Run Database Sync
	Invoke-D365DBSync -ShowOriginalProgress -Verbose
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done DB sync "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxSetDBRecoveryModel.Checked){

	Write-host -ForegroundColor Yellow "Starting "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
	Set-DbaDbRecoveryModel -Verbose -SqlInstance localhost -RecoveryModel Simple -Database AxDB -Confirm:$false
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkboxListOutUserEmails.Checked){

	Write-host -ForegroundColor Yellow "Starting List Out User Email Addresses "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/ListOutUserEmails.ps1)
	Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "select ID, Name, NetworkAlias, NETWORKDOMAIN, Enable from userInfo
	where NETWORKALIAS not like '%@contosoax7.onmicrosoft.com'
	and NETWORKALIAS not like '%@capintegration01.onmicrosoft.com'
	and NETWORKALIAS not like '%@devtesttie.ccsctp.net'
	and NETWORKALIAS not like '%@DAXMDSRunner.com'
	and NETWORKALIAS not like '%@dynamics.com'
	and NETWORKALIAS != ''"
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done List Out User Email Addresses "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

if ($checkbox1.Checked){

	Write-host -ForegroundColor Yellow "Starting Remove-D365Database "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/Remove-D365Database.ps1)
	Stop-D365Environment -All -Kill -Verbose
	Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Remove-D365Database "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
}

Start-D365Environment -All
Write-host -ForegroundColor Yellow "Completed running  "(Get-Date).toString("yyyy-MM-dd hh:mm:ss") 
$mainprogressbaroverlay.Visible = $False
