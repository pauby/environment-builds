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

$packages_install = [ "notepadplusplus", "7zip" ]
package { $packages_install:
  ensure => installed,
}
