$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
Start-Transcript -Path $LogFile -Append -IncludeInvocationHeader

Set-DbaDbRecoveryModel -Verbose -SqlInstance localhost -RecoveryModel Simple -Database AxDB -Confirm:$false

Stop-Transcript 
