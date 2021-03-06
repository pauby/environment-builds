# The Chocolatey provider does not have the ability to install from a local
# nupkg so install it first here.
include chocolatey_local_install

include chocolatey_configure

$packages_install = [ "notepadplusplus", "7zip" ]
package { $packages_install:
  ensure   => installed,
  provider => "chocolatey",
}
