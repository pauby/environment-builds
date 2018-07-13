Param (
    [string]$Path = "$(Join-Path -Path $env:SYSTEMDRIVE -ChildPath 'packages')",

    [string]$PackagesFilename = "packages.txt",

    [int]$WaitSeconds = 5,

    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("Install", "Uninstall")]
    [string]$Mode,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Name,

    [string]$Version,
    [switch]$ChocoDebug
)

$validExitCodes = @(0, 1605, 1614, 1641, 3010)
$packageArgs = @($Mode, $Name, "--allow-downgrade", "--source `"'$Path;http://chocolatey.org/api/v2/'`"")

Write-Host "Managing this package: $Package"

# Build the choco parameters
if ($Version) {
    $packageArgs += "--version=$Version"
}

if ($ChocoDebug) {
    # force the package to install 
    $packageArgs += "-fdvy"
} 
else {
    # force the package to install
    $packageArgs += "-fy"
}

Write-Host "Managing package with this command: choco.exe $($packageArgs -join ' ')"

# run arbitrary win32 application so LASTEXITCODE is 0
& "setx.exe" "trigger" "1"  
Write-Host "Installing package - $packageArgs"
& "choco.exe" $packageArgs
$exitCode = $LASTEXITCODE

Write-Host "Chocolatey exit code was $exitCode"
if ($validExitCodes -notcontains $exitCode) {
    Exit $exitCode
}

Exit 0