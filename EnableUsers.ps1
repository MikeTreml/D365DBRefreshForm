## Enable Users except Guest
  Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "Update USERINFO set ENABLE = 1 where ID != 'Guest'"  | Out-File -FilePath $Logfile
  Update-D365User -email "*@caf2code.com"
 
