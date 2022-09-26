 ## Backup AxDB database

  WriteLog "Backup AxDB" -ForegroundColor Yellow
  $labelInfo = ""
  Invoke-DbaQuery -Verbose -SqlInstance localhost -Database AxDB -Type Full -CompressBackup -BackupFileName "dbname-$NewDB-backuptype-timestamp.bak" -ReplaceInName | Out-File -FilePath $Logfile
  $mainprogressbaroverlay.PerformStep()
