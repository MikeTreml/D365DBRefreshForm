Write-host "List Out User Email Addresses" -ForegroundColor Yellow
Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "
select ID, Name, NetworkAlias, NETWORKDOMAIN, Enable from userInfo
where NETWORKALIAS not like '%@contosoax7.onmicrosoft.com'
and NETWORKALIAS not like '%@capintegration01.onmicrosoft.com'
and NETWORKALIAS not like '%@devtesttie.ccsctp.net'
and NETWORKALIAS not like '%@DAXMDSRunner.com'
and NETWORKALIAS not like '%@dynamics.com'
and NETWORKALIAS != ''" | Out-File -FilePath $Logfile

