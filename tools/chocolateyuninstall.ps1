$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

Uninstall-ChocolateyEnvironmentVariable `
  -VariableName $envDoomWadDir `
  -VariableType Machine

Remove-Item $startMenuDir -recurse -force
Remove-Item $installLocation -recurse -force
