Declare @Command as nvarchar(2000)


set @Command =' ALTER DATABASE ['+ @SourceName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                ALTER DATABASE ['+ @SourceName +'] MODIFY NAME = ['+ @DestinationName +'];
                ALTER DATABASE ['+ @DestinationName + '] SET MULTI_USER;            
                '

exec (@Command)
