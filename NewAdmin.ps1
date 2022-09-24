 ## Promote user as admin and set default tenant  (Optional)
  WriteLog "Setting up new Admin" -ForegroundColor Yellow
  Set-D365Admin -Verbose -AdminSignInName textboxAdminEmailAddress.Text
  $mainprogressbaroverlay.PerformStep()
