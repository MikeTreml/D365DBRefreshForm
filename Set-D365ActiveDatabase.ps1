function Switch-D365ActiveDatabase {
    [CmdletBinding()]
    param (
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Alias('DestinationDatabaseName')]
        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,
        
        [Parameter(Mandatory = $true)]
        [Alias('NewDatabaseName')]
        [string] $SourceDatabaseName,

        [string] $DestinationSuffix = "_original",

        [switch] $EnableException
    )

    $dbToBeName = "$DatabaseName$DestinationSuffix"

    $SqlParamsToBe = @{ DatabaseServer = $DatabaseServer; DatabaseName = "master";
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }
    
    $dbName = Get-D365Database -Name "$dbToBeName" @SqlParamsToBe

    if (-not($null -eq $dbName)) {
        $messageString = "There <c='em'>already exists</c> a database named: <c='em'>`"$dbToBeName`"</c> on the server. You need to run the <c='em'>Remove-D365Database</c> cmdlet to remove the already existing database. Re-run this cmdlet once the other database has been removed."
        Write-PSFMessage -Level Host -Message $messageString -Target $dbToBeName
        Stop-PSFFunction -Message "Stopping because database already exists on the server." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        return
    }

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParamsSource = @{ DatabaseServer = $DatabaseServer; DatabaseName = $SourceDatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }
    write-host $DatabaseName
    $SqlCommand = Get-SqlCommand @SqlParamsSource -TrustedConnection $UseTrustedConnection

    $SqlCommand.CommandText = "SELECT COUNT(1) FROM dbo.USERINFO WHERE ID = 'Admin'"

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Testing the new database for being a valid AXDB database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
        $null = $sqlCommand.ExecuteScalar()
    }
    catch {
        $messageString = "It seems that the new database either <c='em'>doesn't exists</c>, isn't a <c='em'>valid</c> AxDB database or your don't have enough <c='em'>permissions</c>."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
    }
    
    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = "master";
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }
write-host $DatabaseName
    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    
    $commandText = ("Declare @Command as nvarchar(2000) set @Command =' ALTER DATABASE ['+ @SourceName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ALTER DATABASE ['+ @SourceName +'] MODIFY NAME = ['+ @DestinationName +']; ALTER DATABASE ['+ @DestinationName + '] SET MULTI_USER;' exec (@Command)") -join [Environment]::NewLine
 write-host $commandText
    
    $sqlCommand.CommandText = $commandText
    write-host $DatabaseName
    $null = $sqlCommand.Parameters.AddWithValue("@DestinationName", $DatabaseName)
    $null = $sqlCommand.Parameters.AddWithValue("@SourceName", $SourceDatabaseName)
    $null = $sqlCommand.Parameters.AddWithValue("@ToBeName", $dbToBeName)
    write-host $DatabaseName
    write-host $SourceDatabaseName
    write-host $dbToBeName
    write-host $null
    write-host $commandText
    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Switching out the $DatabaseName database with: $SourceDatabaseName." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
        write-host $null
        $null = $sqlCommand.ExecuteNonQuery()
        write-host $null
    }
    catch {
        $messageString = "Something went wrong while <c='em'>switching</c> out the AXDB database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
        
        $sqlCommand.Dispose()
    }
    
    [PSCustomObject]@{
        OldDatabaseNewName = "$dbToBeName"
    }
}
