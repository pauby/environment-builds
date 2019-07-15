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
    syspin $Path 5386
}

if ($StartMenu.IsPresent) {
    syspin $Path 51201
}