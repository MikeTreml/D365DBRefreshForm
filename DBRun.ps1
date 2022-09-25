$ErrorActionPreference = 'Inquire'

$mainprogressbaroverlay.Maximum = 14
$mainprogressbaroverlay.Step = 1
$mainprogressbaroverlay.Value = 0
$mainprogressbaroverlay.Visible = $True
$NewDB = 'AxDB' #Database name. No spaces in the name!
$renameOldFile = $('G:\MSSQL_DATA\AxDB_PrimaryOld_') + $dt + $('.mdf')
[string]$dt = get-date -Format "yyyyMMdd" #Generate the datetime stamp to make DB files unique
count-checkbox

WriteLog "Old File Name  - " $oldFile = Get-Item G:\MSSQL_DATA\AxDB*Primary.mdf -Verbose
Write-Host "Old File Name  - " $oldFile -ForegroundColor Yellow
WriteLog "Rename old File  - " $renameOldFile -ForegroundColor Yellow
Write-Host "Rename old File - " $renameOldFile -ForegroundColor Yellow


WriteLog "Stopping D365FO environment"
Write-Host "Stopping D365FO environment" -ForegroundColor Yellow
Install-D365foDbatools
$mainprogressbaroverlay.PerformStep()
WriteLog "Stopping D365FO environment"
Write-Host "Stopping D365FO environment" -ForegroundColor Green


if ($txtLink.Text -ne '')
{
	#If you are going to download BACPAC file from the LCS Asset Library, please use in this section
	$BacpacSasLinkFromLCS = $txtLink.Text
	
	$TempFolder = 'D:\temp\' # 'c:\temp\'  #$env:TEMP
	#region Download bacpac from LCS
	if ($BacpacSasLinkFromLCS.StartsWith('http'))
	{
        WriteLog "Downloading BACPAC from the LCS Asset library"
		Write-Host "Downloading BACPAC from the LCS Asset library" -ForegroundColor Yellow
		New-Item -Path $TempFolder -ItemType Directory -Force -Verbose
		$TempFileName = Join-path $TempFolder -ChildPath "$NewDB.bacpac"
		
        WriteLog "..Downloading file" $TempFileName
		Write-Host "..Downloading file" $TempFileName -ForegroundColor Green
		
		Invoke-D365InstallAzCopy -Verbose
		Invoke-D365AzCopyTransfer -SourceUri $BacpacSasLinkFromLCS -DestinationUri $TempFileName -ShowOriginalProgress -Verbose
		
		$f = Get-ChildItem $TempFileName
		$NewDB = $($f.BaseName).Replace(' ', '_')
	}
}
elseif ($txtFile.Text -ne '')
{
	$f = Get-ChildItem $txtFile.Text #Please note that this file should be accessible from SQL server service account
	$NewDB = $($f.BaseName).Replace(' ', '_') + $('_') + $dt; #'AxDB_CTS1005BU2'  #Temporary Database name for new AxDB. Use a file name or any meaningful name.
}
$mainprogressbaroverlay.PerformStep()

## Stop D365FO instance.
WriteLog "Stopping D365FO environment"
Write-Host "Stopping D365FO environment" -ForegroundColor Yellow
Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Stopping D365FO environment"
Write-Host "Stopping D365FO environment" -ForegroundColor Yellow


WriteLog "truncate"
Write-Host "truncate" -ForegroundColor Yellow
Clear-D365BacpacTableData -Path "D:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY", "BATCHJOBHISTORY", "SYSSERVERCONFIG", "SYSSERVERSESSIONS", "SYSCORPNETPRINTERS", "SYSCLIENTSESSIONS", "BATCHSERVERCONFIG", "BATCHSERVERGROUP" -ClearFromSource -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "truncate"
Write-Host "truncate" -ForegroundColor Yellow


WriteLog "Enable-D365Exception"
Write-Host  "Enable-D365Exception"
Enable-D365Exception -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Enable-D365Exception"
Write-Host "Enable-D365Exception"


WriteLog "Installing modern SqlPackage"
Write-Host  "Installing modern SqlPackage"
Invoke-D365InstallSqlPackage -Verbose #Installing modern SqlPackage just in case  
$mainprogressbaroverlay.PerformStep()
WriteLog "Installing modern SqlPackage"
Write-Host  "Installing modern SqlPackage"


WriteLog "Checking SQL file"
Write-Host  "Checking SQL file"
If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName)))
{
	Write-Warning "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
	throw "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
}
$mainprogressbaroverlay.PerformStep()
WriteLog "Checking SQL file"
Write-Host  "Checking SQL file"


WriteLog "Unblock-File"
Write-Host  "Unblock-File"
$f | Unblock-File
$mainprogressbaroverlay.PerformStep()
WriteLog "Unblock-File"
Write-Host  "Unblock-File"


WriteLog "Import-D365Bacpac"
Write-Host  "Import-D365Bacpac"
Import-D365Bacpac -ImportModeTier1 -BacpacFile $f.FullName -NewDatabaseName $NewDB -ShowOriginalProgress
$mainprogressbaroverlay.PerformStep()
WriteLog "Import-D365Bacpac"
Write-Host  "Import-D365Bacpac"


## Removing AxDB_orig database and Switching AxDB:   NULL <-1- AxDB_original <-2- AxDB <-3- [NewDB]
WriteLog "Stopping D365FO environment and Switching Databases" -ForegroundColor Yellow
Write-Host  "Stopping D365FO environment and Switching Databases" -ForegroundColor Yellow
Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Stopping D365FO environment and Switching Databases" -ForegroundColor Yellow
Write-Host  "Stopping D365FO environment and Switching Databases" -ForegroundColor Yellow


WriteLog "Switch-D365ActiveDatabase"
Write-Host  "Switch-D365ActiveDatabase"
Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Switch-D365ActiveDatabase"
Write-Host  "Switch-D365ActiveDatabase"


WriteLog "Remove-D365Database"
Write-Host  "Remove-D365Database"
Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Remove-D365Database"
Write-Host  "Remove-D365Database"


WriteLog "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow
Write-Host  "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow
Start-D365Environment
$mainprogressbaroverlay.PerformStep()
WriteLog "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow
Write-Host  "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow



WriteLog "Stop-Service MSSQLSERVER, SQLSERVERAGENT"
Write-Host  "Stop-Service MSSQLSERVER, SQLSERVERAGENT"
Stop-Service MSSQLSERVER, SQLSERVERAGENT -Force -Verbose
WriteLog "Stop-Service MSSQLSERVER, SQLSERVERAGENT"
Write-Host  "Stop-Service MSSQLSERVER, SQLSERVERAGENT"

[string]$dt = get-date -Format "yyyyMMdd"
$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
[string]$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf' -Exclude AxDB*$dt*Primary.mdf


if ($oldFile -ne '')
{
	WriteLog "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
	Write-Host  "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
	Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_$dt.mdf
	#Remove-D365Database -DatabaseName 'AxDB_Original'
    WriteLog "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
	Write-Host  "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
}


#
WriteLog "Start-Service MSSQLSERVER, SQLSERVERAGENT "
Write-Host  "Start-Service MSSQLSERVER, SQLSERVERAGENT "
Start-Service MSSQLSERVER, SQLSERVERAGENT -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Start-Service MSSQLSERVER, SQLSERVERAGENT "
Write-Host  "Start-Service MSSQLSERVER, SQLSERVERAGENT "

if ($checkbox1.Checked)
{
	Write-Host "Starting 1" -ForegroundColor Yellow
	WriteLog "Starting 1"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done 1"
	WriteLog "Done 1"
}
if ($checkbox2.Checked)
{
	Write-Host "Starting 2" -ForegroundColor Yellow
	WriteLog "Starting 2"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/2)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done 2"
	WriteLog "Done 2"
}
if ($checkbox3.Checked)
{
	Write-Host "Starting 3" -ForegroundColor Yellow
	WriteLog "Starting 3"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/3)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done 3"
	WriteLog "Done 3"
}
if ($checkbox4.Checked)
{
	Write-Host "Starting 4" -ForegroundColor Yellow
	WriteLog "Starting 4"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/4)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done 4" -ForegroundColor Yellow
	WriteLog "Done 4"
}
if ($checkbox5.Checked)
{
	Write-Host "Starting 5" -ForegroundColor Yellow
	WriteLog "Starting 5"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/5)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done 5"
	WriteLog "Done 5"
}
if ($checkboxBackupNewlyCompleted.Checked)
{
	Write-Host "Starting Backup AxDB" -ForegroundColor Yellow
	WriteLog "Starting Backup AxDB"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BackUpDB.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done Backup AxDB"
	WriteLog "Done Backup AxDB"
}

if ($checkboxCleanUpPowerBISettin.Checked)
{
	Write-Host "Starting Cleaning up Power BI settings"  -ForegroundColor Yellow
	WriteLog "Starting Cleaning up Power BI settings"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done Cleaning up Power BI settings"
	WriteLog "Done Cleaning up Power BI settings"
}

if ($checkboxEnableSQLChangeTrack.Checked)
{
	Write-Host "Starting SQL Tracking"
	WriteLog "Starting SQL Tracking"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SQLTracking.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done SQL Tracking"
	WriteLog "Done SQL Tracking"
}

if ($checkboxPromoteNewAdmin.Checked)
{
	Write-Host "Starting New Admin"
	WriteLog "Starting New Admin"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/NewAdmin.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done New Admin"
	WriteLog "Done New Admin"
}

if ($checkboxTruncateBatchTables.Checked)
{
	Write-Host "Starting truncate Batch"
	WriteLog "Starting truncate Batch"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done truncate Batch"
	WriteLog "Done truncate Batch"
}

if ($checkboxPutAllBatchJobsOnHol.Checked)
{
	Write-Host "Starting hold batch jobs"
	WriteLog "Starting hold batch jobs"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done hold batch jobs"
	WriteLog "Done hold batch jobs"
}

if ($checkboxRunDatabaseSync.Checked)
{
	Write-Host "Starting DB sync"
	WriteLog "Starting DB sync"
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done DB sync"
	WriteLog "Done DB sync"
}

if ($checkboxSetDBRecoveryModel.Checked)
{
	Write-Host  "Starting "
	WriteLog "Starting "
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done"
	WriteLog "Done"
}


if ($checkboxEnableUsersExceptGue.Checked)
{
	Write-Host "Starting Enable Users"
	WriteLog "Starting Enable Users"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/EnableUsers.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host "Done Enable Users"
	WriteLog "Done Enable Users"
}

if ($checkboxListOutUserEmails.Checked)
{
	Write-Host "Starting List Out User Email Addresses"
	WriteLog "Starting List Out User Email Addresses"
	Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/ListOutUserEmails.ps1)
	$mainprogressbaroverlay.PerformStep()
	Write-Host  "Done List Out User Email Addresses" -ForegroundColor Green
	WriteLog "Done List Out User Email Addresses"
}

Write-Host  "Completed running" -ForegroundColor Green
WriteLog "Completed running"
$mainprogressbaroverlay.Visible = $False


