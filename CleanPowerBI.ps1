$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp\PowerBIClean.txt"
Start-Transcript -Path $LogFile -Append -Force

## Clean up Power BI settings
Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''"  | Out-File -FilePath $Logfile

Stop-Transcript
