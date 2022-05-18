for ($i = 1; $i -le 100; $i++ )
{
Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i
Start-Sleep -Milliseconds 250
} 
