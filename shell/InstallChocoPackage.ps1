[CmdletBinding()]
Param (
    [string[]]
    $Name,

    [string]
    $Version,

    [switch]
    $UseLocalSource
)

if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install packages."
}
else {
    $Name | ForEach-Object {
        $cmd = "choco upgrade $_ -y --no-progress --limit-output"
        if ($Version) {
            $cmd += " --version $Version"
        }

        if ($UseLocalSource.IsPresent) {
            $cmd += " --source c:\packages"
        }

        Write-Output "Installing Chocolatey package '$_' with command '$cmd'."
        Invoke-Expression -Command $cmd
    }
}