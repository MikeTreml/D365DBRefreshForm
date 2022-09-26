WriteLog "Installing PowerShell modules d365fo.tools and dbatools" -ForegroundColor Yellow
Write-Host "Installing PowerShell modules d365fo.tools and dbatools" -ForegroundColor Yellow

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$modules2Install = @('d365fo.tools', 'dbatools')
foreach ($module in $modules2Install)
{
  WriteLog "..working on module $module"
  Write-Host  "..working on module $module"
  if ($null -eq $(Get-Command -Module $module))
  {
    WriteLog "....installing module $module" -ForegroundColor Gray
    Write-Host  "....installing module $module" -ForegroundColor Gray
    Install-Module -Name $module -SkipPublisherCheck -Scope AllUsers -Verbose
  }
  else
  {
    WriteLog "....updating module" $module -ForegroundColor Gray
    Write-Host  "....updating module" $module -ForegroundColor Gray
    Update-Module -Name $module -Verbose
  }
  $mainprogressbaroverlay.PerformStep()
}

