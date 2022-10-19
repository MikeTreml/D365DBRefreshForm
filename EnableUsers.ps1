
Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "INSERT INTO [AxDB].[dbo].[USERINFO]
([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES ('aniela','aniela',1,'PQI','https://sts.windows.net/caf2code.com/','aniela@caf2code.com',1,'en-us','en-us',29,2,1,1,1);
INSERT INTO [AxDB].[dbo].[USERINFO]
([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('justin','justin',1,'PQI','https://sts.windows.net/caf2code.com/','justin@caf2code.com',1,'en-us','en-us',29,2,1,1,1);"

Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('mike', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('benbreeden', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('Brittany', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('d.ki21', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('L.FL21', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('laurenwooll', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('m.ri21', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('mac', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('r.qu21', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('justin', 2, 1, 1, 0, 0);
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID)
values('aniela', 2, 1, 1, 0, 0);"

Enable-D365User -Email "*caf2code*"
Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "Update USERINFO set ENABLE = 1 where ID != 'Guest'"  | Out-File -FilePath $Logfile
update-D365User -Email "*caf2code*"


 
