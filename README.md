# Vagrant Builds

All of my code and templates for Vagrant builds.

## Folder Structure

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

## Environment Setup

The machines are all built using a `vagrant-config.json` file in the respective folder. The Vagrantfile that we use in each folder is a symbolic link to the `Vagrantfile.template` in the root folder. Make sure you are in the folder you want to create the Vagrantfile in and run, from PowerShell, `New-Item -ItemType SymbolicLink -Target ..\Vagrantfile.template -Path Vagrantfile`.

Some environments need you to specify the machine to bring up. To find the machine names either look at the `vagrant-config.json` file or run `vagrant status`. To bring the machine up either use `vagrant up` or `vagrant up <MACHINENAME>`.

### vagrant-config.json

This file is where the configuration for the machine is held. See [`vagrant-config.json.template`](https://github.com/pauby/environment-builds/blob/master/vagrant-config.json.template) for help.

### Hyper-V

When running Vagrant under Hyper-V you will be prompted for an account with permissions to create shares to use for synced folders. You will be prompted on Vagrant up, at machine reboot / reload. To get around this you can create two environment variables with those details and they will be used instead. These environment variables are fairly self explanatory:

* VAGRANT_HYPERV_SMB_USERNAME
* VAGRANT_HYPERV_SMB_PASSWORD

This obviously creates a security risk. To minimise this create the variables in the user scope / context. I have looked into encrypting these with DPAPI but decrypting them again inside the Vagrantfile has caused me problems that I haven't yet been able to address. If you have any solutions please create an [issue](https://github.com/paub/yenvironment-builds/issues).

Creating the variables is optional. If you don't create these variables you will prompted for the credentials as normal.