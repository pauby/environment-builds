[CmdletBinding()]
Param (
    [string[]]
    $Package,

    [string]
    $PackageVersion
)

if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install packages."
}
else {
    $Package | ForEach-Object {
        Write-Output "Installing Chocolatey package '$_'."
        $cmd = "choco upgrade $_ -y --no-progress"
        if ($PackageVersion) {
            $cmd += " --version $PackageVersion"
        }

        Invoke-Expression -Command $cmd
    }
}