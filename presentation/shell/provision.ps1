Write-Host "Setting Environment Variables"
[System.Environment]::SetEnvironmentVariable("LocalChocoPackages", "c:\resources\packages", "Machine")
[System.Environment]::SetEnvironmentVariable("LocalChocoLicenses", "c:\resources\licenses", "Machine")

Write-Host "Add Desktop Presentation Shortcuts"
# Taken from https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\\Desktop\\VS Code Presentation.lnk")
$Shortcut.TargetPath = "C:\\Program Files\\Microsoft VS Code\\Code.exe"
$Shortcut.Save()

$bytes = [System.IO.File]::ReadAllBytes("$Home\\Desktop\\VS Code Presentation.lnk")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$Home\\Desktop\\VS Code Presentation.lnk", $bytes)

#git clone https://github.com/pauby/presentations c:\\git-presentations --depth 1 -q
Remove-Variable -Name 'Shortcut' -Force -ErrorAction SilentlyContinue
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\\Desktop\\Open Jenkins.lnk")
$Shortcut.TargetPath = "C:\\Program Files\\Internet Explorer\\iexplore.exe"
$Shortcut.Arguments = "http://localhost:8080"
$Shortcut.Save()

Write-Host "Create Zoomit Startup Shortcut"
$WshShell = New-Object -comObject WScript.Shell
$link = Join-Path -Path ([Environment]::GetFolderPath('Startup')) -ChildPath 'Zoomit.lnk'
$Shortcut = $WshShell.CreateShortcut($link)
$Shortcut.TargetPath = (Join-Path -Path $env:ChocolateyInstall -Childpath 'bin\\zoomit.exe')
$Shortcut.Save()

# Launch Zoomit
& (Join-Path -Path $env:ChocolateyInstall -Childpath 'bin/zoomit.exe')