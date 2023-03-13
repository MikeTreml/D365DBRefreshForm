
Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "TRUNCATE TABLE SYSSERVERCONFIG
TRUNCATE TABLE SYSSERVERSESSIONS
TRUNCATE TABLE SYSCORPNETPRINTERS
TRUNCATE TABLE SYSCLIENTSESSIONS
TRUNCATE TABLE BATCHSERVERCONFIG
TRUNCATE TABLE BATCHSERVERGROUP
TRUNCATE TABLE BatchHistory
TRUNCATE TABLE BatchJobHistory
TRUNCATE TABLE DMFSTAGINGVALIDATIONLOG
TRUNCATE TABLE DMFSTAGINGEXECUTIONERRORS
TRUNCATE TABLE DMFSTAGINGLOGDETAILS
TRUNCATE TABLE DMFSTAGINGLOG 
TRUNCATE TABLE DMFDEFINITIONGROUPEXECUTIONHISTORY
TRUNCATE TABLE DMFEXECUTION
TRUNCATE TABLE DMFDEFINITIONGROUPEXECUTION" 

Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "declare @t table 
(id bigint identity(1,1), sqlQuery nvarchar(500))
declare @maxid bigint, @i	bigint, @sqlquery nvarchar(500)
insert into @t (sqlQuery)
select ' truncate table ' + name from sysobjects where name like '%staging'
select @maxid = MAX(id) from @t
set @i=1
while (@i<=@maxid)
BEGIN
select @sqlquery = sqlQuery from @t where id = @i
exec(@sqlQuery)
set @i=@i+1
END"

