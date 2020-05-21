include prepare_windows

include set_windows_autologon

include configure_windows_networking

# The Chocolatey provider does not have the ability to install from a local
# nupkg so install it first here.
include chocolatey_local_install

include chocolatey_configure

# disable the Chocolatey source
chocolateysource { 'chocolatey':
  ensure => disabled,
}

include vm_guest_tools

include setup_bginfo

$packages_install = [ "notepadplusplus", "7zip", "boxstarter" ]
package { $packages_install:
  ensure   => installed,
  provider => "chocolatey",
}
