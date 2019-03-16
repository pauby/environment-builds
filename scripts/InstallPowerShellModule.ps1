#Requires -RunAsAdministrator

[CmdletBinding()]
Param (
    # Hashtable:
    #   Same parameters as Install-Module - Name is mandatory
    [hashtable[]]
    $RequiredModule
)

# dependencies
$provider = Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue
$providerMinVersion = '2.8.5.201'
if (-not ($provider) -or $provider.Version -lt [Version]$providerMinVersion) {
    $null = Install-PackageProvider -Name NuGet -MinimumVersion $providerMinVersion -Force
    Write-Verbose "Bootstrapping NuGet package provider version $providerMinVersion."
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
}

# Setting the InstallationPolicy of the repository can take a long time so check
# it first (quicker).
if ((Get-PsRepository -Name PSGallery).InstallationPolicy -ne "Trusted") {
    Write-Verbose "Setting InstallationPolicy for PSGallery to 'Trusted'."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

$RequiredModule | ForEach-Object {
    if (-not (Get-Module -Name $_.Name -ListAvailable)) {
        Write-Verbose "Installing module '$($_.Name)'."
        Install-Module @_ -SkipPublisherCheck -AllowClobber
    }
    else {
        Write-Verbose "Module '$($_.Name)' already installed."
    }
    Import-Module -Name $_.Name -Force
}