[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [ValidateScript( { Test-Path $_ } )]
    [string]
    $Path,

    [switch]
    $Taskbar,

    [switch]
    $StartMenu
)

# install the syspin package first
if ((Get-Command -Name 'syspin.exe' -ErrorAction SilentlyContinue) -ne $true) {
    # assuming Chocolatey is installed
    choco install syspin -y
}

if ($Taskbar.IsPresent) {
    $taskbarPinLink = Join-Path -Path ([Environment]::GetFolderPath('CommonStartup')) -ChildPath 'PinPowerShellToTaskbar.lnk'

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($taskbarPinLink)
    $Shortcut.TargetPath = "syspin.exe"
    $Shortcut.Arguments = "$Path 5386"
    $Shortcut.Save()
}

if ($StartMenu.IsPresent) {
    $startmenuPinLink = Join-Path -Path ([Environment]::GetFolderPath('CommonStartup')) -ChildPath 'PinPowerShellToStartMenu.lnk'

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($startmenuPinLink)
    $Shortcut.TargetPath = "syspin.exe"
    $Shortcut.Arguments = "$Path 51201"
    $Shortcut.Save()
}