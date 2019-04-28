[CmdletBinding()]
Param (
    [string[]]
    $Name,

    [string]
    $Version
)

if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install packages."
}
else {
    $Name | ForEach-Object {
        $cmd = "choco upgrade $_ -y --no-progress"
        if ($Version) {
            $cmd += " --version $Version"
        }

        Write-Output "Installing Chocolatey package '$_' with command '$cmd'."
        Invoke-Expression -Command $cmd
    }
}