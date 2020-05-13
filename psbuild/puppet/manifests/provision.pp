# The Chocolatey provider does not have the ability to install from a local
# nupkg so install it first here.
include chocolatey_local_install

include chocolatey_configure

case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

$packages_install = [ "git", "iridium-browser", "firefox", "notepadplusplus", "nuget.commandline", "syspin" ]
package { $packages_install:
  ensure => installed,
}

# #
# # Prepare PowerShell Build Environment
# #

# file { [  'C:/Program Files/PackageManagement',
#           'C:/Program Files/PackageManagement/ProviderAssemblies',
#           'C:/Program Files/PackageManagement/ProviderAssemblies/nuget',
#           'C:/Program Files/PackageManagement/ProviderAssemblies/nuget/2.8.5.208'
#   ]:
#   ensure => 'directory',
# }

# file { 'Nuget':
#   ensure  => 'file',
#   path    => "C:/Program Files/PackageManagement/ProviderAssemblies/nuget/2.8.5.208/Microsoft.PackageManagement.NuGetProvider.dll",
#   source  => "c:/assets/Microsoft.PackageManagement.NuGetProvider.dll",
#   require => File['C:/Program Files/PackageManagement/ProviderAssemblies/nuget/2.8.5.208'],
# }

# exec { 'PSGallery':
#   command  => 'Set-PSRepository -Name PSGallery -InstallationPolicy Trusted',
#   provider => 'powershell',
#   onlyif   => 'if ((Get-PSRepository -Name PSGallery).InstallationPolicy -eq "Trusted") { Exit 1 } else { Exit 0 }',
#   require  => File['Nuget']
# }

# # pester already exists on some version of windows so ehck the version
# exec { 'pester-module':
#   provider => 'powershell',
#   command  => '[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; Install-Module -Name Pester -Force -SkipPublisherCheck',
#   onlyif   => 'if ((Get-Module -Name pester -ListAvailable | Sort Version -Descending | Select -First 1).Version -lt [version]"4.10") { Exit 0 } else { Exit 1 }'
# }

# exec { 'psscriptanalyzer-module':
#   provider => 'powershell',
#   command  => '[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; Install-Module -Name PSScriptAnalyzer -Scope AllUsers',
#   onlyif   => 'Exit (Get-Module -Name PSScriptAnalyzer -ListAvailable).count'
# }



