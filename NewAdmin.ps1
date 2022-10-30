$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
Start-Transcript -Path $LogFile -Append -UseMinimalHeader -Force

## Promote user as admin and set default tenant  (Optional)
Set-D365Admin -Verbose -AdminSignInName textboxAdminEmailAddress.Text

Stop-Transcript 
