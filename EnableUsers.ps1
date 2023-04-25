$co = Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query " SELECT count(COMPANY) as c, COMPANY FROM USERINFO group by COMPANY  order by c desc"
Import-D365ExternalUser -Id "Aniela" -Name "Aniela" -Email "aniela@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Mike" -Name "Mike" -Email "mike@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Ben" -Name "Ben" -Email "ben@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Brittany" -Name "Brittany" -Email "Brittany@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "d.ki21" -Name "d.ki21" -Email "d.ki21@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "L.FL21" -Name "L.FL21" -Email "L.FL21@caf2code.com" -Company $co.company[0] -Enabled 1
Import-D365ExternalUser -Id "Mac" -Name "Mac" -Email "mac@caf2code.com" -Company $co.company[0] -Enabled 1
Enable-D365User -Email "*caf2code*"
update-D365User -Email "*caf2code*"
