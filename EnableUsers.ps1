$co = Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query " SELECT count(COMPANY) as c, COMPANY FROM USERINFO group by COMPANY  order by c desc"
		
$roleId = Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "SELECT RECID FROM SECURITYROLE where name = 'System administrator'"

Import-D365ExternalUser -Id "Aniela" -Name "Aniela" -Email "aniela@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Mike" -Name "Mike" -Email "mike@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Ben" -Name "Ben" -Email "ben@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Brittany" -Name "Brittany" -Email "Brittany@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "d.ki21" -Name "d.ki21" -Email "d.ki21@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "L.FL21" -Name "L.FL21" -Email "L.FL21@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Mac" -Name "Mac" -Email "mac@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Justin" -Name "Justin" -Email "justin@caf2code" -Company $co.company[0] -Enabled 1

$line2 = ' insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('

$str = "{2}'mike', {1}, 1, 1, 0, 0)
    {2}'benbreeden', {1}, 1, 1, 0, 0)
    {2}'Brittany', {1}, 1, 1, 0, 0)
    {2}'d.ki21', {1}, 1, 1, 0, 0)
    {2}'L.FL21', {1}, 1, 1, 0, 0)
    {2}'mac', {1}, 1, 1, 0, 0)
    {2}'justin', {1}, 1, 1, 0, 0)
    {2}'aniela', {1}, 1, 1, 0, 0)
    UPDATE USERINFO SET COMPANY = '{0}' WHERE NETWORKALIAS like '%caf2code.com'
    Update USERINFO set ENABLE = 1 where ID != 'Guest'" -f $co, $roleId[0], $line2

Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query $str
Enable-D365User -Email "*caf2code*"
update-D365User -Email "*caf2code*"
