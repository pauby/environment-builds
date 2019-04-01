# cChoco Environment Build

This environment will be used to test out changes to the [cChoco](https://github.com/chocolatey/cchoco) module.

## Environment Configuration

The environment is build using Vagrant and currently contains only one machine with the following spec:

* Windows Server 2012 R2
* 1GB RAM

The following software is installed:

* Chocolatey (latest version available - a local source is also configured to save some packages being downloaded from the internet);
* Visual Studio Code (version 1.32.3)

## How To Test

Create a DSC configuration as follows:

``` powershell
Configuration AddSource
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName cChoco

    Node localhost
    {
        cChocoInstaller InstallChocolatey
        {
            InstallDir = "c:\choco"
        }

        cChocoPackageInstaller 'Install dummy-pkg'
        {
            Name        = 'dummy-pkg'
            Ensure      = 'Present'
            AutoUpgrade = $false
            Version     = 1.0.0
            Source      = 'c:\packages'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }
    }
}

AddSource
```

This creates the MOF file in the folder names `addsource`. Once that is done run `Start-DscConfiguration addsource -wait -verbose -force`.