$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp\Remove-D365Database..txt"
Start-Transcript -Path $LogFile -Append -Force

Stop-D365Environment -All -Kill -Verbose
Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose


Stop-Transcript
