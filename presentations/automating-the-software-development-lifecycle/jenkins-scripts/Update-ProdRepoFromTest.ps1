<#
.NOTES
    Written by Paul Broadwith (paul@pauby.com) October 2018
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]
    $ProdRepo,

    [Parameter(Mandatory)]
    [string]
    $ProdRepoApiKey,

    [Parameter(Mandatory)]
    [string]
    $TestRepo
)

. .\ConvertTo-ChocoObject.ps1

# get all of the packages from the test repo
$testPkgs = choco.exe list --source $TestRepo -r | ConvertTo-ChocoObject
$prodPkgs = choco.exe list --source $ProdRepo -r | ConvertTo-ChocoObject
$tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID
if ($null -eq $testPkgs) {
    Write-Verbose "Test repository appears to be empty. Nothing to push to production."
    exit 0
}
elseif ($null -eq $prodPkgs) {
    $pkgs = $testPkgs
}
else {
    $pkgs = Compare-Object -ReferenceObject $testpkgs -DifferenceObject $prodpkgs -Property name, version |
        Where-Object SideIndicator -eq '<='
}

$pkgs | ForEach-Object {
    Write-Verbose "Downloading package '$($_.name)' to '$tempPath'."
    choco.exe download $_.name --no-progress --output-directory=$tempPath --source=$TestRepo --force --limitoutput

    if ($LASTEXITCODE -eq 0) {
        # #######################
        # INSERT CODE HERE TO TEST YOUR PACKAGE
        # #######################
        $pkgPath = (Get-Item -Path (Join-Path -Path $tempPath -ChildPath "$($_.name)*.nupkg")).FullName
        $failed = (Invoke-Pester -Script @{ Path = '.\Test-Package.ps1'; Parameters = @{ Path = $pkgPath; Name = $_.name } } -Passthru).FailedCount
        if ($failed) {
            break
        }

        # If package testing is successful ...
        if (-not $failed) {
            Write-Verbose "Pushing downloaded package '$(Split-Path -Path $pkgPath -Leaf)' to production repository '$ProdRepo'."
            choco.exe push $pkgPath --source=$ProdRepo --api-key=$ProdRepoApiKey --force --limitoutput

            if ($LASTEXITCODE -eq 0) {
                Write-Verbose "Pushed package successfully."
            }
            else {
                Write-Verbose "Could not push package."
            }
        }
        else {
            Write-Verbose "Package testing failed."
        }

        Remove-Item -Path $pkgPath -Force
    }
    else {
        Write-Verbose "Could not download package."
    }
}
