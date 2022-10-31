$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp\NewAdmin.txt"
Start-Transcript -Path $LogFile -Append -Force

## Promote user as admin and set default tenant  (Optional)
Set-D365Admin -Verbose -AdminSignInName textboxAdminEmailAddress.Text

Stop-Transcript 
