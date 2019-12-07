$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"
. "$(Join-Path $toolsDir dependenciesEnv.ps1)"

$url = 'https://github.com/freedoom/freedoom/releases/download/v0.11.3/freedoom-0.11.3.zip'
$freeDoomZip = "$(Join-Path $env:TEMP 'freedoom-0.11.3.zip')"
$freeDoomArgs = @{
  packageName     = 'FreeDoomWads'
  fileFullPath    = $freeDoomZip
  url             = $url
  checksum        = '28A5EAFBB1285B78937BD408FCDD8F25F915432340EEE79DA692EAE83BCE5E8A'
  checksumType    = 'sha256'
}
Get-ChocolateyWebFile @freeDoomArgs
7z.exe e -aoa -bd -bb1 -o"$installLocation" -y "$freeDoomZip" 'freedoom-0.11.3/*.*'

Install-ChocolateyEnvironmentVariable `
  -VariableName $envDoomWadDir `
  -VariableValue "$installLocation" `
  -VariableType Machine

Install-ChocolateyShortcut `
  -ShortcutFilePath "$(Join-Path $startMenuDir FreeDoom.lnk)" `
  -TargetPath "$(Join-Path $zandronumLocation zandronum.exe)" `
  -IconLocation "$(Join-Path $toolsDir 'assets\playa2a8.ico')" `
  -WorkingDirectory "$installLocation"
