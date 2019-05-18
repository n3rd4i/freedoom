$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zandronumLocation = "$ENV:LocalAppData\Programs\Zandronum"
$installLocation = "$ENV:LocalAppData\Programs\FreeDoom"
$shortcutPath = "$ENV:UserProfile\Desktop\FreeDoom.lnk"
New-Item -ItemType Directory -Force -Path $installLocation

$freeDoomZip = Join-Path $env:TEMP 'freedoom-0.11.3.zip'
$freeDoomArgs = @{
  packageName     = 'FreeDoomWads'
  fileFullPath    = $freeDoomZip
  url             = 'https://github.com/freedoom/freedoom/releases/download/v0.11.3/freedoom-0.11.3.zip'
  # unzipLocation   = $installLocation
  softwareName  = 'freedoom*'
  checksum        = '55E9A2C7A24651D63654407D2CEC26C2'
  checksumType    = 'md5'
}
Get-ChocolateyWebFile @freeDoomArgs
7z.exe e -aoa -bd -bb1 -o"$installLocation" -y "$freeDoomZip" 'freedoom-0.11.3/*.*'

Install-ChocolateyEnvironmentVariable `
  -VariableName "DOOMWADDIR" `
  -VariableValue "$installLocation" `
  -VariableType 'User'

Install-ChocolateyShortcut `
  -ShortcutFilePath "$shortcutPath" `
  -TargetPath "$zandronumLocation\zandronum.exe" `
  -IconLocation "$toolsDir\assets\freedoom1.ico" `
  -Description "FreeDoom version 0.11.3" `
  -WorkingDirectory "$installLocation"
