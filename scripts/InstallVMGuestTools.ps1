$provider = (Get-WmiObject -Class Win32_ComputerSystem).Model

switch ($provider) {
    "virtualbox" {
        & \scripts\InstallChocoPackage.ps1 -Name virtualbox-guest-additions-guest.install -Version 6.0.4
    }
}