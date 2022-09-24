## Enable Users except Guest
  WriteLog "Enable all users except Guest" -ForegroundColor Yellow
  #Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "Update USERINFO set ENABLE = 1 where ID != 'Guest'"
  Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "Update USERINFO set ENABLE = 1 where ID != 'Guest'"
  Update-D365User
  $mainprogressbaroverlay.PerformStep()
