$ErrorActionPreference = 'Inquire'
$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
#Start-Transcript -OutputDirectory $LogFile
$mainprogressbaroverlay.Maximum = 10
$mainprogressbaroverlay.Step = 1
$mainprogressbaroverlay.Value = 0
$mainprogressbaroverlay.Visible = $True

[string]$dt = get-date -Format "yyyyMMdd" 
$NewDB = 'AxDB_'+$dt
count-checkbox

Write-host -ForegroundColor Yellow "Stopping D365FO environment"
Install-D365foDbatools
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Stopping D365FO environment"


if ($txtLink.Text -ne ''){
	#If you are going to download BACPAC file from the LCS Asset Library, please use in this section
	$BacpacSasLinkFromLCS = $txtLink.Text
	
	$TempFolder = 'D:\temp\' # 'c:\temp\'  #$env:TEMP
	#region Download bacpac from LCS
	if ($BacpacSasLinkFromLCS.StartsWith('http'))	{
       		Write-host -ForegroundColor Yellow "Downloading BACPAC from the LCS Asset library"
		New-Item -Path $TempFolder -ItemType Directory -Force -Verbose
		$TempFileName = Join-path $TempFolder -ChildPath "$NewDB.bacpac"
        	Write-host -ForegroundColor Yellow "..Downloading file" $TempFileName

		Invoke-D365InstallAzCopy -Verbose
		Invoke-D365AzCopyTransfer -SourceUri $BacpacSasLinkFromLCS -DestinationUri $TempFileName -ShowOriginalProgress -Verbose
		Write-host -ForegroundColor Green "Done ..Downloading file" $TempFileName
		$f = Get-ChildItem $TempFileName
		$NewDB = $($f.BaseName).Replace(' ', '_')
	}
}
elseif ($txtFile.Text -ne ''){
	$f = Get-ChildItem $txtFile.Text #Please note that this file should be accessible from SQL server service account
	$NewDB = $($f.BaseName).Replace(' ', '_') + $('_') + $dt; #'AxDB_CTS1005BU2'  #Temporary Database name for new AxDB. Use a file name or any meaningful name.
}
$mainprogressbaroverlay.PerformStep()

## Stop D365FO instance.
Write-host -ForegroundColor Yellow "Stopping D365FO environment"
Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Stopping D365FO environment"


#if ($checkboxTruncateBatchTables.Checked){
	#Write-host -ForegroundColor Yellow "truncate"
	#Clear-D365BacpacTableData -Path "D:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY", "BATCHJOBHISTORY", "SYSSERVERCONFIG", "SYSSERVERSESSIONS", "SYSCORPNETPRINTERS", "SYSCLIENTSESSIONS", "BATCHSERVERCONFIG", "BATCHSERVERGROUP" -ClearFromSource -Verbose
	#$mainprogressbaroverlay.PerformStep()
	#Write-host -ForegroundColor Green "Done truncate"

#}

Write-host -ForegroundColor Yellow "Enable-D365Exception"
Enable-D365Exception -Verbose
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Enable-D365Exception"



Write-host -ForegroundColor Yellow "Installing modern SqlPackage"
Invoke-D365InstallSqlPackage -Verbose 
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Installing modern SqlPackage"



Write-host -ForegroundColor Yellow "Checking SQL file"
If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName))){
	Write-Warning "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
	throw "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
}
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Checking SQL file"


Write-host -ForegroundColor Yellow "Unblock-File"
$f | Unblock-File
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Unblock-File"


Write-host -ForegroundColor Yellow "Import-D365Bacpac "
Import-D365Bacpac -ImportModeTier1 -BacpacFile $f.FullName -NewDatabaseName $NewDB -ShowOriginalProgress
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Import-D365Bacpac"


## Stopping enviroment again before switch
#Write-host -ForegroundColor Yellow "Stopping D365FO environment and Switching Databases" 
#Stop-D365Environment -All -Kill -Verbose
#Write-host -ForegroundColor Yellow "Stopping D365FO environment and Switching Databases" 


if(Get-SqlDatabase -ServerInstance localhost -Name "AxDB"){
	Write-host -ForegroundColor Yellow "Switch-D365ActiveDatabase"
	Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose
#	Invoke-DbaQuery -SqlInstance localhost -Database master -Query "
#ALTER DATABASE AxDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
#ALTER DATABASE AxDB MODIFY NAME = AxDB_Original;
#ALTER DATABASE AxDB_Original SET MULTI_USER;
#ALTER DATABASE '$NewDB' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
#ALTER DATABASE '$NewDB' MODIFY NAME = AxDB;
#ALTER DATABASE AxDB SET MULTI_USER;
#ALTER DATABASE AxDB SET AUTO_CLOSE OFF WITH NO_WAIT"
	Write-host -ForegroundColor Green "Done Switch-D365ActiveDatabase"
}
else{
	Write-host -ForegroundColor Yellow "set-D365ActiveDatabase"
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/Set-D365ActiveDatabase.ps1)
	Invoke-DbaQuery -SqlInstance localhost -Database master -Query "
ALTER DATABASE '$NewDB' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE '$NewDB' MODIFY NAME = AxDB;
ALTER DATABASE AxDB SET MULTI_USER;
ALTER DATABASE AxDB SET AUTO_CLOSE OFF WITH NO_WAIT"
	Write-host -ForegroundColor Green "Done set-D365ActiveDatabase"
}
$mainprogressbaroverlay.PerformStep()
### Manual remove is a better option
#Write-host -ForegroundColor Yellow "Remove-D365Database"
#Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
#Write-host -ForegroundColor Green "Done Remove-D365Database"



Write-host -ForegroundColor Yellow "Starting D365FO environment. Then open UI and refresh Data Entities." 
Start-D365Environment
$mainprogressbaroverlay.PerformStep()
Write-host -ForegroundColor Green "Done Starting D365FO environment. Then open UI and refresh Data Entities." 





if ($checkbox2.Checked){

	Write-host -ForegroundColor Yellow "Starting 2"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/2)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 2"
}

if ($checkbox3.Checked){

	Write-host -ForegroundColor Yellow "Starting 3"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/3)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 3"
}

if ($checkbox4.Checked){

	Write-host -ForegroundColor Yellow "Starting 4"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/4)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 4"
}

if ($checkbox5.Checked){

	Write-host -ForegroundColor Yellow "Starting 5"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/5)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done 5"
}

if ($checkboxBackupNewlyCompleted.Checked){

	Write-host -ForegroundColor Yellow "Starting Backup AxDB"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BackUpDB.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Backup AxDB"
}

if ($checkboxCleanUpPowerBISettin.Checked){

	Write-host -ForegroundColor Yellow "Starting Cleaning up Power BI settings"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Cleaning up Power BI settings"
}

if ($checkboxEnableSQLChangeTrack.Checked){

	Write-host -ForegroundColor Yellow "Starting SQL Tracking"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SQLTracking.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done SQL Tracking"
}

if ($checkboxPromoteNewAdmin.Checked){

	Write-host -ForegroundColor Yellow "Starting New Admin"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/NewAdmin.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done New Admin"
}

if ($checkboxTruncateBatchTables.Checked){

	Write-host -ForegroundColor Yellow "Starting truncate Batch"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done truncate Batch"
}

if ($checkboxPutAllBatchJobsOnHol.Checked){

	Write-host -ForegroundColor Yellow "Starting hold batch jobs"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done hold batch jobs"
}

if ($checkboxRunDatabaseSync.Checked){

	Write-host -ForegroundColor Yellow "Starting DB sync"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done DB sync"
}

if ($checkboxSetDBRecoveryModel.Checked){

	Write-host -ForegroundColor Yellow "Starting "
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done"
}

if ($checkboxEnableUsersExceptGue.Checked){

	Write-host -ForegroundColor Yellow "Starting Enable Users"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/EnableUsers.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Enable Users"
}

if ($checkboxListOutUserEmails.Checked){

	Write-host -ForegroundColor Yellow "Starting List Out User Email Addresses"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/ListOutUserEmails.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done List Out User Email Addresses"
}

if ($checkbox1.Checked){

	Write-host -ForegroundColor Yellow "Starting Remove-D365Database"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/Remove-D365Database)
	$mainprogressbaroverlay.PerformStep()
	Write-host -ForegroundColor Green "Done Remove-D365Database"
}

Write-host -ForegroundColor Yellow "Completed running"
$mainprogressbaroverlay.Visible = $False

Stop-Transcript


