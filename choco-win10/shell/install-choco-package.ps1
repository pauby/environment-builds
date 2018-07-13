Param (
    [Parameter()]
    [string]$Path = "$(Join-Path -Path $env:SYSTEMDRIVE -ChildPath 'packages')",

    [string]$PackagesFilename = "packages.txt",

    [int]$WaitSeconds = 5,

    [string]$Package
)
Write-Host "Packager to install: $Package"
$validExitCodes = @(0, 1605, 1614, 1641, 3010)

# First test if path exists
if (!(Test-Path -Path $Path)) {
    throw "Packages path $Path does not exist."
}

# Check if there is a packages.txt file in the packages folder and install the packages from there
$packageFilePath = Join-Path -Path $Path -ChildPath $PackagesFilename
if (Test-Path -Path $packageFilePath) {
    Get-Content -Path $packageFilePath | ForEach-Object {
        $packageArgs = @()
        if (![string]::IsNullOrEmpty($_)) {
            $scratch = $_.Trim() -split " "
            # we dont do any sanity checking here s it's down to who created the package file
            $packageArgs += $scratch[0]
            if ($scratch.count -eq 3) {
                # we must have a version and args so add the version with it's parameter and then the args
                $packageArgs += "--version=$($scratch[1])"
                $packageArgs += $scratch[2] -split " "
            }
            elseif (($scratch.count -eq 2) -and ($scratch[1] -match "\d\.")) {
                # we have a version number only so add it and it's parameter
                $packageArgs += "--version=$($scratch[1])"
            }
            elseif ($scratch.count -eq 2) {
                # we just have argument so concat them
                $packageArgs += $scratch[1] -split ' '
            }

            # run arbitrary win32 application so LASTEXITCODE is 0
            & "setx.exe" "trigger" "1"  
            Write-Host "Installing package - $packageArgs"
            & "choco.exe" "install" "-fdvy" $packageArgs "--allow-downgrade" "--source `"'c:\\packages;http://chocolatey.org/api/v2/'`""
            $exitCode = $LASTEXITCODE

            Write-Host "Install exit code was $exitCode"
            if ($validExitCodes -notcontains $exitCode) {
                Exit $exitCode
            }

<#            Write-Host $("#" * 50)
            Write-Host "#"
            Write-Host "Waiting for $WaitSeconds before uninstalling package."
            Start-Sleep -Seconds $WaitSeconds
            Write-Host "#"
            Write-Host $("#" * 50)

            Write-Host "Uninstalling package - $packageArgs"
            & "choco.exe" "uninstall" "-fdvy" $packageArgs
            $exitCode = $LASTEXITCODE

            Write-Host "Uninstall exit code was $exitCode"
            if ($validExitCodes -notcontains $exitCode) {
                Exit $exitCode
            } #>
        }
        else {
            Write-Warning "Line '$_' is not in the correct format in package file $packageFilePath. Skipping."
        }
    }
}
else {
    Write-Warning "Package file list $packageFilePath does not exist."
}

Exit 0