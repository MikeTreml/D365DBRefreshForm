$ErrorActionPreference = 'Inquire'

$mainprogressbaroverlay.Maximum = 10
$mainprogressbaroverlay.Step = 1
$mainprogressbaroverlay.Value = 0
$mainprogressbaroverlay.Visible = $True

[string]$dt = get-date -Format "yyyyMMdd" 
$NewDB = 'AxDB_'+$dt
count-checkbox

WriteLog "Stopping D365FO environment"
Install-D365foDbatools
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Stopping D365FO environment"


if ($txtLink.Text -ne ''){
	#If you are going to download BACPAC file from the LCS Asset Library, please use in this section
	$BacpacSasLinkFromLCS = $txtLink.Text
	
	$TempFolder = 'D:\temp\' # 'c:\temp\'  #$env:TEMP
	#region Download bacpac from LCS
	if ($BacpacSasLinkFromLCS.StartsWith('http'))	{
       		WriteLog "Downloading BACPAC from the LCS Asset library"
		New-Item -Path $TempFolder -ItemType Directory -Force -Verbose
		$TempFileName = Join-path $TempFolder -ChildPath "$NewDB.bacpac"
        	WriteLog "..Downloading file" $TempFileName

		Invoke-D365InstallAzCopy -Verbose
		Invoke-D365AzCopyTransfer -SourceUri $BacpacSasLinkFromLCS -DestinationUri $TempFileName -ShowOriginalProgress -Verbose
		WriteLog "Done ..Downloading file" $TempFileName
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
WriteLog "Stopping D365FO environment"
Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Stopping D365FO environment"


#if ($checkboxTruncateBatchTables.Checked){
	#WriteLog "truncate"
	#Clear-D365BacpacTableData -Path "D:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY", "BATCHJOBHISTORY", "SYSSERVERCONFIG", "SYSSERVERSESSIONS", "SYSCORPNETPRINTERS", "SYSCLIENTSESSIONS", "BATCHSERVERCONFIG", "BATCHSERVERGROUP" -ClearFromSource -Verbose
	#$mainprogressbaroverlay.PerformStep()
	#WriteLog "Done truncate"

#}

WriteLog "Enable-D365Exception"
Enable-D365Exception -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Enable-D365Exception"



WriteLog "Installing modern SqlPackage"
Invoke-D365InstallSqlPackage -Verbose 
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Installing modern SqlPackage"



WriteLog "Checking SQL file"
If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName))){
	Write-Warning "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
	throw "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
}
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Checking SQL file"


WriteLog "Unblock-File"
$f | Unblock-File
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Unblock-File"


WriteLog "Import-D365Bacpac"
Import-D365Bacpac -ImportModeTier1 -BacpacFile $f.FullName -NewDatabaseName $NewDB -ShowOriginalProgress
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Import-D365Bacpac"


## Stopping enviroment again before switch
#WriteLog "Stopping D365FO environment and Switching Databases" 
#Stop-D365Environment -All -Kill -Verbose
#WriteLog "Stopping D365FO environment and Switching Databases" 


if(Get-SqlDatabase -ServerInstance localhost -Name "AxDB"){
	WriteLog "Switch-D365ActiveDatabase"
	#Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose
	Invoke-DbaQuery -SqlInstance localhost -Database master -Query "
ALTER DATABASE AxDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE AxDB MODIFY NAME = AxDB_Original;
ALTER DATABASE AxDB_Original SET MULTI_USER;
ALTER DATABASE '$NewDB' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE '$NewDB' MODIFY NAME = AxDB;
ALTER DATABASE AxDB SET MULTI_USER;
ALTER DATABASE AxDB SET AUTO_CLOSE OFF WITH NO_WAIT"
	WriteLog "Done Switch-D365ActiveDatabase"
}
else{
	WriteLog "set-D365ActiveDatabase"
	#Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/Set-D365ActiveDatabase.ps1)
	Invoke-DbaQuery -SqlInstance localhost -Database master -Query "
ALTER DATABASE '$NewDB' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE '$NewDB' MODIFY NAME = AxDB;
ALTER DATABASE AxDB SET MULTI_USER;
ALTER DATABASE AxDB SET AUTO_CLOSE OFF WITH NO_WAIT"
	WriteLog "Done set-D365ActiveDatabase"
}
$mainprogressbaroverlay.PerformStep()
### Manual remove is a better option
#WriteLog "Remove-D365Database"
#Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
#WriteLog "Done Remove-D365Database"



WriteLog "Starting D365FO environment. Then open UI and refresh Data Entities." 
Start-D365Environment
$mainprogressbaroverlay.PerformStep()
WriteLog "Done Starting D365FO environment. Then open UI and refresh Data Entities." 



if ($checkbox1.Checked){

	WriteLog "Starting 1"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done 1"
}

if ($checkbox2.Checked){

	WriteLog "Starting 2"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/2)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done 2"
}

if ($checkbox3.Checked){

	WriteLog "Starting 3"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/3)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done 3"
}

if ($checkbox4.Checked){

	WriteLog "Starting 4"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/4)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done 4"
}

if ($checkbox5.Checked){

	WriteLog "Starting 5"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/5)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done 5"
}

if ($checkboxBackupNewlyCompleted.Checked){

	WriteLog "Starting Backup AxDB"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BackUpDB.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done Backup AxDB"
}

if ($checkboxCleanUpPowerBISettin.Checked){

	WriteLog "Starting Cleaning up Power BI settings"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done Cleaning up Power BI settings"
}

if ($checkboxEnableSQLChangeTrack.Checked){

	WriteLog "Starting SQL Tracking"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SQLTracking.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done SQL Tracking"
}

if ($checkboxPromoteNewAdmin.Checked){

	WriteLog "Starting New Admin"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/NewAdmin.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done New Admin"
}

if ($checkboxTruncateBatchTables.Checked){

	WriteLog "Starting truncate Batch"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done truncate Batch"
}

if ($checkboxPutAllBatchJobsOnHol.Checked){

	WriteLog "Starting hold batch jobs"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done hold batch jobs"
}

if ($checkboxRunDatabaseSync.Checked){

	WriteLog "Starting DB sync"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done DB sync"
}

if ($checkboxSetDBRecoveryModel.Checked){

	WriteLog "Starting "
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done"
}

if ($checkboxEnableUsersExceptGue.Checked){

	WriteLog "Starting Enable Users"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/EnableUsers.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done Enable Users"
}

if ($checkboxListOutUserEmails.Checked){

	WriteLog "Starting List Out User Email Addresses"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/ListOutUserEmails.ps1)
	$mainprogressbaroverlay.PerformStep()
	WriteLog "Done List Out User Email Addresses"
}

writeLog "Completed running"
$mainprogressbaroverlay.Visible = $False


