$Stamp = (Get-Date).toString("yyyy-MM-dd")
$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$Stamp"
Start-Transcript -Path $LogFile -Append -IncludeInvocationHeader

Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES ('aniela','aniela',1,'PQI','https://sts.windows.net/caf2code.com/','aniela@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('mike','mike',1,'PQI','https://sts.windows.net/caf2code.com/','mike@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('benbreeden','benbreeden',1,'PQI','https://sts.windows.net/caf2code.com/','benbreeden@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('Brittany','Brittany',1,'PQI','https://sts.windows.net/caf2code.com/','Brittany@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('d.ki21','d.ki21',1,'PQI','https://sts.windows.net/caf2code.com/','d.ki21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('L.FL21','L.FL21',1,'PQI','https://sts.windows.net/caf2code.com/','L.FL21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('laurenwooll','laurenwooll',1,'PQI','https://sts.windows.net/caf2code.com/','laurenwooll@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('m.ri21','m.ri21',1,'PQI','https://sts.windows.net/caf2code.com/','m.ri21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('mac','mac',1,'PQI','https://sts.windows.net/caf2code.com/','mac@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('r.qu21','r.qu21',1,'PQI','https://sts.windows.net/caf2code.com/','r.qu21@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('aniela','aniela',1,'PQI','https://sts.windows.net/caf2code.com/','aniela@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
INSERT INTO [AxDB].[dbo].[USERINFO]([ID],[NAME],[ENABLE],[COMPANY],[NETWORKDOMAIN],[NETWORKALIAS],[ENABLEDONCE],[LANGUAGE],[HELPLANGUAGE],[PREFERREDTIMEZONE],[ACCOUNTTYPE],[DEFAULTPARTITION],[EXTERNALIDTYPE],[INTERACTIVELOGON])
VALUES	('justin','justin',1,'PQI','https://sts.windows.net/caf2code.com/','justin@caf2code.com',1,'en-us','en-us',29,2,1,1,1)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('mike', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('benbreeden', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('Brittany', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('d.ki21', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('L.FL21', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('laurenwooll', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('m.ri21', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('mac', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('r.qu21', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('justin', 2, 1, 1, 0, 0)
insert into securityuserrole(USER_, SECURITYROLE, ASSIGNMENTSTATUS, ASSIGNMENTMODE, VALIDFROMTZID, VALIDTOTZID) values('aniela', 2, 1, 1, 0, 0)
UPDATE [dbo].[USERINFO] SET [COMPANY] = 'PQI' WHERE NETWORKALIAS like '%caf2code.com'
Update USERINFO set ENABLE = 1 where ID != 'Guest'"

Enable-D365User -Email "*caf2code*"
update-D365User -Email "*caf2code*"

Stop-Transcript
