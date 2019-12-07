$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"
. "$(Join-Path $toolsDir dependenciesEnv.ps1)"

$url = 'https://github.com/freedoom/freedoom/releases/download/v0.12.1/freedoom-0.12.1.zip'
$zipBaseName = [IO.Path]::GetFileName($url)
$zipName = [IO.Path]::GetFileNameWithoutExtension($url)

$freeDoomZip = "$(Join-Path $env:TEMP $zipBaseName)"
$freeDoomArgs = @{
  packageName     = 'FreeDoomWads'
  fileFullPath    = $freeDoomZip
  url             = $url
  checksum        = 'F42C6810FC89B0282DE1466C2C9C7C9818031A8D556256A6DB1B69F6A77B5806'
  checksumType    = 'sha256'
}
Get-ChocolateyWebFile @freeDoomArgs
7z.exe e -aoa -bd -bb1 -o"$installLocation" -y "$freeDoomZip" "$zipName/*.*"

Install-ChocolateyEnvironmentVariable `
  -VariableName $envDoomWadDir `
  -VariableValue "$installLocation" `
  -VariableType Machine

Install-ChocolateyShortcut `
  -ShortcutFilePath "$(Join-Path $startMenuDir FreeDoom.lnk)" `
  -TargetPath "$(Join-Path $zandronumLocation zandronum.exe)" `
  -IconLocation "$(Join-Path $toolsDir 'assets\playa2a8.ico')" `
  -WorkingDirectory "$installLocation"
