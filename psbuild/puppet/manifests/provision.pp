include pauby_vagrant_provision

include pauby_vagrant_provision::win_os_provision

include pauby_vagrant_provision::win_chocolatey_configuration_standard

include pauby_vagrant_provision::win_chocolatey_source_local_add

# disable the Chocolatey source
chocolateysource { 'chocolatey':
  ensure => disabled,
}

case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

$packages_install = [ "git", "iridium-browser", "firefox", "notepadplusplus", "nuget.commandline", "syspin" ]
package { $packages_install:
  ensure => installed,
}

# dont install any PowerShell modules here as it's important they are installed from the module build
