$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
Start-Transcript -Path $LogFile -Append -IncludeInvocationHeader

Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "
select ID, Name, NetworkAlias, NETWORKDOMAIN, Enable from userInfo
where NETWORKALIAS not like '%@contosoax7.onmicrosoft.com'
and NETWORKALIAS not like '%@capintegration01.onmicrosoft.com'
and NETWORKALIAS not like '%@devtesttie.ccsctp.net'
and NETWORKALIAS not like '%@DAXMDSRunner.com'
and NETWORKALIAS not like '%@dynamics.com'
and NETWORKALIAS != ''" | Out-File -FilePath $Logfile

Stop-Transcript
