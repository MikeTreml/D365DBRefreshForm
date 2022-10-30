$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
Start-Transcript -Path $LogFile -Append -UseMinimalHeader -Force

Stop-D365Environment -All -Kill -Verbose
Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose


Stop-Transcript
