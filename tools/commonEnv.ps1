# Common env vars
$AppName = 'FreeDoom'
$installLocation = "$(Join-Path $toolsDir $AppName)"
$startMenuDir = [IO.Path]::Combine($ENV:ProgramData, 'Microsoft\Windows\Start Menu\Programs', $AppName)

$envDoomWadDir = 'DOOMWADDIR'
