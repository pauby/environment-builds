$provider = (Get-WmiObject -Class Win32_ComputerSystem).Model

switch ($provider) {
    "virtualbox" {
        choco upgrade virtualbox-guest-additions-guest.install --version 6.0.4 -y
    }
}