$ErrorActionPreference = 'Inquire'

$mainprogressbaroverlay.Maximum = 12
$mainprogressbaroverlay.Step = 1
$mainprogressbaroverlay.Value = 0
$mainprogressbaroverlay.Visible = $True
count-checkbox

[string]$dt = get-date -Format "yyyyMMdd" #Generate the datetime stamp to make DB files unique

WriteLog $oldFile = Get-Item G:\MSSQL_DATA\AxDB*Primary.mdf -Verbose
$renameOldFile = $('G:\MSSQL_DATA\AxDB_PrimaryOld_') + $dt + $('.mdf')
WriteLog $oldFile -ForegroundColor Yellow
WriteLog $renameOldFile -ForegroundColor Yellow
Start-Sleep -Seconds 3;
Install-D365foDbatools 
$NewDB = 'AxDB' #Database name. No spaces in the name!
Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY","SYSSERVERCONFIG","SYSSERVERSESSIONS","SYSCORPNETPRINTERS","SYSCLIENTSESSIONS","BATCHSERVERCONFIG","BATCHSERVERGROUP" -ClearFromSource -Verbose

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
  $NewDB = $($f.BaseName).Replace(' ', '_') + $('_') + $dt; #'AxDB_CTS1005BU2'  #Temporary Database name for new AxDB. Use a file name or any meaningful name.
}
$mainprogressbaroverlay.PerformStep()

## Stop D365FO instance.
WriteLog "Stopping D365FO environment" -ForegroundColor Yellow

Stop-D365Environment -All -Kill -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Enable-D365Exception"
Enable-D365Exception -Verbose
$mainprogressbaroverlay.PerformStep()
WriteLog "Start SQLbar"
Start-Job -ScriptBlock { Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/pbar.ps1) }
WriteLog "SQL bar"
start-sleep -seconds 10
WriteLog "Installing modern SqlPackage"
Invoke-D365InstallSqlPackage -Verbose #Installing modern SqlPackage just in case  
$mainprogressbaroverlay.PerformStep()
## Import bacpac to SQL Database
WriteLog "Checking SQL file"
If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName)))
{
  Write-Warning "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
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
Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose

$mainprogressbaroverlay.PerformStep()
WriteLog "Remove-D365Database"
Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
$mainprogressbaroverlay.PerformStep()

## Start D365FO instance
WriteLog "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow
Start-D365Environment
$mainprogressbaroverlay.PerformStep()
#move the file
WriteLog "Stop-Service MSSQLSERVER, SQLSERVERAGENT"
Stop-Service MSSQLSERVER, SQLSERVERAGENT -Force -Verbose

[string]$dt = get-date -Format "yyyyMMdd"
$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
[string]$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf' -Exclude AxDB*$dt*Primary.mdf
if ($oldFile -ne '')
{
  WriteLog "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
  Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_$dt.mdf
  #Remove-D365Database -DatabaseName 'AxDB_Original'
}
WriteLog "Start-Service MSSQLSERVER, SQLSERVERAGENT "
Start-Service MSSQLSERVER, SQLSERVERAGENT -Verbose
$mainprogressbaroverlay.PerformStep()

if ($checkboxBackupNewlyCompleted.Checked)
{
  WriteLog "Starting Backup AxDB" -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BackUpDB.ps1)
  $mainprogressbaroverlay.PerformStep()
  WriteLog "Done Backup AxDB" -ForegroundColor Yellow
}

if ($checkboxCleanUpPowerBISettin.Checked)
{
  WriteLog "Starting Cleaning up Power BI settings" -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
  $mainprogressbaroverlay.PerformStep()
  WriteLog "Done Cleaning up Power BI settings" -ForegroundColor Yellow
}

if ($checkboxEnableSQLChangeTrack.Checked)
{
 WriteLog "Starting SQL Tracking" -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://github.com/MikeTreml/D365DBRefreshForm/blob/main/SQLTracking.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done SQL Tracking" -ForegroundColor Yellow
}

if ($checkboxPromoteNewAdmin.Checked)
{
 WriteLog "Starting New Admin" -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/NewAdmin.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done New Admin" -ForegroundColor Yellow
}

if ($checkboxTruncateBatchTables.Checked)
{
 WriteLog "Starting truncate Batch" -ForegroundColor Yellow
 Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done truncate Batch" -ForegroundColor Yellow
}

if ($checkboxPutAllBatchJobsOnHol.Checked)
{
 WriteLog "Starting hold batch jobs" -ForegroundColor Yellow
   Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
   $mainprogressbaroverlay.PerformStep()
    WriteLog "Done hold batch jobs" -ForegroundColor Yellow
}

if ($checkboxRunDatabaseSync.Checked)
{
 WriteLog "Starting DB sync" -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done DB sync" -ForegroundColor Yellow
}

if ($checkboxSetDBRecoveryModel.Checked)
{
 WriteLog "Starting " -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done" -ForegroundColor Yellow
}


if ($checkboxEnableUsersExceptGue.Checked)
{
  WriteLog "Starting Enable Users" -ForegroundColor Yellow
 Invoke-Expression $(Invoke-WebRequest  https://github.com/MikeTreml/D365DBRefreshForm/blob/main/EnableUsers.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done Enable Users" -ForegroundColor Yellow
}

if ($checkboxListOutUserEmails.Checked)
{
  WriteLog "Starting List Out User Email Addresses" -ForegroundColor Yellow
  Invoke-Expression $(Invoke-WebRequest  https://github.com/MikeTreml/D365DBRefreshForm/blob/main/ListOutUserEmails.ps1)
  $mainprogressbaroverlay.PerformStep()
   WriteLog "Done List Out User Email Addresses" -ForegroundColor Yellow
}
WriteLog "Completed running" -ForegroundColor Yellow
