$ErrorActionPreference = 'Stop'; # stop on all errors
$installLocation = "$ENV:LOCALAPPDATA\Programs\FreeDoom\*"
$shortcutPath = "$ENV:UserProfile\Desktop\FreeDoom.lnk"
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'ZIP'
  softwareName  = 'freedoom*'
  zipFileName   = 'freedoom-0.11.3.zip'
}
Remove-Item $installLocation -recurse -force
Remove-Item $shortcutPath -force
Uninstall-ChocolateyEnvironmentVariable -VariableName 'DOOMWADDIR' -VariableType 'User'

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']
if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)" #NOTE: You may need to split this if it contains spaces, see below
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    } else {
      Uninstall-ChocolateyZipPackage @packageArgs
    }
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
