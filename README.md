# Vagrant Builds

All of my code and templates for Vagrant builds.

## Setup

Before you start make sure you have a `resources` folder structure as below:

```text
resources
   |
   |_ packages
   |_ licenses
```

This folder should either be in the root of the repository or created elsewhere and a symbolic link created to it in the root of this repository. This is the way I have it setup.

The folders are for:

* packages - is used to hold all of the internalized packages (see [SetupResources.ps1](https://github.com/pauby/environment-builds/blob/master/SetupResources.ps1) in the root of the repository);
* licenses - holds your Chocolatey license which must be named a particular way (see the [shell\DeployChocolateyLicense.ps1](https://github.com/pauby/environment-builds/blob/master/shell/DeployChocolateyLicense.ps1) for more information):
  * Professional - prof-chocolatey.license.xml
  * Business - bus-chocolatey.license.xml
  * Architect - arch-chocolatey.license.xml
  * MSP - msp-chocolatey.license.xml
