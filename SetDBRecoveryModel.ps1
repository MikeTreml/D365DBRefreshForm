$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp\SetDBRecoveryModel.txt"
Start-Transcript -Path $LogFile -Append -Force

Set-DbaDbRecoveryModel -Verbose -SqlInstance localhost -RecoveryModel Simple -Database AxDB -Confirm:$false

Stop-Transcript 
