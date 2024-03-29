Write-Host "Installing PowerShell modules d365fo.tools and dbatools "(Get-Date).toString("yyyy-MM-dd hh:mm:ss")  -ForegroundColor Yellow

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$modules2Install = @('d365fo.tools', 'dbatools')
foreach ($module in $modules2Install)
{
  Write-Host  "..working on module $module"
  if ($null -eq $(Get-Command -Module $module))
  {
    Write-Host  "....installing module $module" -ForegroundColor Gray
    Install-Module -Name $module -SkipPublisherCheck -Scope AllUsers -Verbose
  }
  else
  {
    Write-Host  "....updating module" $module -ForegroundColor Gray
    Update-Module -Name $module -Verbose
  }
  
}
Write-Host "Done Installing PowerShell modules d365fo.tools and dbatools  "(Get-Date).toString("yyyy-MM-dd hh:mm:ss")  -ForegroundColor Green

