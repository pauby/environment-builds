class { 'pauby_vagrant_provision::win_updates':
  ensure => 'manual',
}

# The Chocolatey provider does not have the ability to install from a local
# nupkg so install it first here.
include pauby_vagrant_provision::win_chocolatey_configuration_standard

include pauby_vagrant_provision::win_chocolatey_source_local_add
