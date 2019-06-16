[CmdletBinding()]
Param (
    [string]
    $PackagePath = "resources\packages",
    # use this to download and internalize the packages again regardless of whether the version exists or not
    [switch]
    $Force
)

Write-Warning 'NOTE: This script requires you to have Chocolatey For Business to internalize packages.'

$PackagePath = Resolve-Path -Path $PackagePath
if (-not (Test-Path -Path $PackagePath)) {
    Write-Error "The packages path '$PackagePath' must exist."
}

# Licensed Feed
# Chocolatey FOSS and Commercial
@( 'chocolatey' ) | ForEach-Object {
    if ($Force.IsPresent -or (-not (Test-Path -Path (Join-Path -Path $PackagePath -ChildPath "$_.*.nupkg")))) {
        choco download $_ --internalize --internalize-all-urls --append-use-original-location --output-directory=$PackagePath --source="'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/'"
    }
}

@(  'chocolateygui', 'dotnet4.5.2', 'chocolatey.server', 'dotnet4.6.1', 'KB2919355', 'KB2919442',
    'baretail', 'dotnetversiondetector', 'notepadplusplus', 'vscode', 'git', 'bginfo',
    'virtualbox-guest-additions-guest.install', 'chromium', 'pester', 'psscriptanalyzer', 
    'chocolatey.server', 'zoomit' ) | ForEach-Object {
    if ($Force.IsPresent -or (-not (Test-Path -Path (Join-Path -Path $PackagePath -ChildPath "$_.*.nupkg")))) {
        choco download $_ --internalize --internalize-all-urls --append-use-original-location --output-directory=$PackagePath --source="'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/''"
    }
}

# Download Jenkins
if ($Force.IsPresent -or (-not (Test-Path -Path (Join-Path -Path $PackagePath -ChildPath "jenkins.nupkg")))) {
    choco.exe download jenkins --version 2.164.3 --internalize --internalize-all-urls `
        --append-use-original-location --output-directory=$PackagePath `
        --source="'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/''"
}

# Download .NET 4 Installer
$NetFx4Url = 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe'
$NetFx4Path = 'resources\installers\dotNetFx40_Full_x86_x64.exe'
Invoke-WebRequest -Uri $NetFx4Url -OutFile $NetFx4Path -UseBasicParsing

Write-Warning "Need to place the chocolatey.extension package in '$PackagePath'."