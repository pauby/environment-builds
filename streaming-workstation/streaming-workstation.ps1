$labConfig = @{
    Name = 'StreamingWorkstation'
    DefaultVirtualizationEngine = 'HyperV'
    VmPath = 'c:\vm\automatedlab'
}

New-LabDefinition @labConfig

Add-LabVirtualNetworkDefinition -Name 'Default Switch' -HyperVProperties @{SwitchType = 'External'; AdapterName = 'Ethernet' }
$netAdapter = New-LabNetworkAdapterDefinition -VirtualSwitch 'Default Switch' -UseDhcp

Add-LabMachineDefinition -Name 'pauby-host' -Processors 2 -Memory 1GB -MinMemory 1GB -MaxMemory 8GB `
    -OperatingSystem 'Windows Server 2019 Datacenter Evaluation (Desktop Experience)' `
    -NetworkAdapter $netAdapter
    # -UserLocale 'en-GB' -TimeZone 'GMT'

Install-Lab

Invoke-LabCommand -ActivityName 'Installing Chocolatey ...' -ComputerName (Get-LabVM) `
    -Filename 'InstallChocolatey.ps1' -DependencyFolderPath $PSScriptRoot -NoDisplay

Restart-LabVm (Get-LabVm)

Show-LabDeploymentSummary