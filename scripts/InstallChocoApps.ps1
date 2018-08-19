[CmdletBinding()]
Param (
    [string[]]
    $Package
)

$Package | ForEach-Object {
    Write-Output "Installing Chocolatey package '$_'."
    choco upgrade $_ -y --no-progress
}