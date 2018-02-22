# Vagrant File (Vagrantfile)
# http://docs.vagrantup.com/v2/vagrantfile/index.html

Vagrant.require_version ">= 2.0.0"

require './vagrant-provision-reboot-plugin'
require 'json'

if File.exists?(File.expand_path "./package.json")  
    packages = JSON.parse(File.read(File.expand_path "./package.json"))
      puts packages
end  

# Need the vagrant reload plugin to reboot the box
unless Vagrant.has_plugin?("vagrant-reload")
  raise 'vagrant-reload plugin is not installed! Please install it with: vagrant plugin install vagrant-reload'
end

# http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html
Vagrant.configure("2") do |config|
  # This setting will download the atlas box at
  # https://atlas.hashicorp.com/ferventcoder/boxes/win2012r2-x64-nocm
  config.vm.box = "win10-ent-x64-trial"

  config.vm.provider :hyperv do |h|
    # 4GB RAM
    h.memory = 512
	  h.maxmemory = 4096
    # 2 CPUs
    h.cpus = 1
	# Integration Services
    h.vm_integration_services = {
      guest_service_interface: true,
      heartbeat: true,
      key_value_pair_exchange: true,
      shutdown: true,
      time_synchronization: true,
      vss: true
    }
    # Huge performance gain here
    h.differencing_disk = true
  end
  
  # timeout of waiting for image to stop running - may be a deprecated setting
  config.windows.halt_timeout = 20
  # username/password for accessing the image
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"
  # explicitly tell Vagrant the guest is Windows
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  
  # Synced folders - http://docs.vagrantup.com/v2/synced-folders/
  # A synced folder is a fancy term for shared folders - it takes a folder on
  # the host and shares it with the guest (vagrant) image. The entire folder
  # where the Vagrantfile is located is always shared as `c:\vagrant` (the
  # naming of this directory being `vagrant` is just a coincedence).
  # Share `packages` directory as `C:\packages`
  # Turn off the default vagrant synced folder as they don't work
  config.vm.synced_folder ".", "/vagrant", disabled: true
  #config.vm.synced_folder "packages", "c:/packages", "type": "rsync", create: true
  #config.vm.synced_folder "temp", "/Users/vagrant/AppData/Local/Temp/chocolatey"
  # not recommended for sharing, it may have issues with `vagrant sandbox rollback`
  #config.vm.synced_folder "chocolatey", "/ProgramData/chocolatey"

  # Port forward WinRM / RDP
  config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
  config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true

  # Provisioners - http://docs.vagrantup.com/v2/provisioning/
  config.vm.provision "shell", inline: "New-Item (Join-Path -Path $env:SYSTEMDRIVE -ChildPath 'packages') -ItemType Directory -Force | Out-Null", name: "Creating remote packages folder"
  config.vm.provision "file", source: "../shell/win-build-toolkit.psm1", destination: "c:/tmp/win-build-toolkit.psm1"
  config.vm.provision "file", source: "./packages", destination: "c:/packages", run: "always"

  packages.each do |package|
    puts package
#    puts package['name']
    # In this specific vagrant usage, we are using the shell provisioner
    # http://docs.vagrantup.com/v2/provisioning/shell.html
    config.vm.provision :shell, :path => "../shell/PrepareWindows.ps1", :powershell_elevated_interactive => true
    # Installing .NET 4 is not needed on Win 10
    #config.vm.provision :shell, :path => "../shell/InstallNet4.ps1", :powershell_elevated_interactive => true
    config.vm.provision :shell, :path => "../shell/InstallChocolatey.ps1", :powershell_elevated_interactive => true
    config.vm.provision :shell, :path => "../shell/NotifyGuiAppsOfEnvironmentChanges.ps1", :powershell_elevated_interactive => true

    if package['install'] == true 
      config.vm.provision "shell", path: "../shell/Manage-ChocoPackage.ps1", args: "-Mode install -Name #{package['name']} -ChocoDebug", powershell_elevated_interactive: true, name: "Installing package #{package['name']}"
      if package['rebootafterinstall'] == true
        config.vm.provision "reload"
      else
        sleep 10
      end
    end

    if package['uninstall'] == true
      config.vm.provision "shell", path: "../shell/Manage-ChocoPackage.ps1", args: "-Mode uninstall -Name #{package['name']} -ChocoDebug", powershell_elevated_interactive: true, name: "Uninstalling package #{package['name']}"
      if package['rebootafteruninstall'] == true
        config.vm.provision "reload"
      end
    end 
  end # packages
#$packageTestScript = <<SCRIPT
#setx.exe trigger 1  # run arbitrary win32 application so LASTEXITCODE is 0
#$ErrorActionPreference = "Stop"
#$env:PATH +=";$($env:SystemDrive)\\ProgramData\\chocolatey\\bin"
## https://github.com/chocolatey/choco/issues/512
#$validExitCodes = @(0, 1605, 1614, 1641, 3010)
#
#Write-Output "Testing package if a line is uncommented."
## THIS IS WHAT YOU CHANGE
## - uncomment one of the two and edit it appropriately
## - See the README for details
##choco.exe install -fdvy INSERT_NAME --version INSERT_VERSION  --allow-downgrade
##choco.exe install -fdvy INSERT_NAME  --allow-downgrade --source "'c:\\packages;http://chocolatey.org/api/v2/'"

#$exitCode = $LASTEXITCODE

#Write-Host "Exit code was $exitCode"
#if ($validExitCodes -contains $exitCode) {
#  Exit 0
#}

#Exit $exitCode
#SCRIPT

#  if Vagrant::VERSION < '1.8.0'
#    config.vm.provision :shell, :inline => $packageTestScript
#  else
#    config.vm.provision :shell, :inline => $packageTestScript, :powershell_elevated_interactive => true
#  end
end