# Adapted from http://stackoverflow.com/a/29571064/18475
# Get the OS
$osData = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName

# check if we have Internet Explorer installed
if ([bool](Get-Command -Name 'iexplore.exe'  -ErrorAction SilentlyContinue)) {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    if (Test-Path $AdminKey) {
        New-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force | Out-Null
        Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for Admin."
    }

    if (Test-Path $UserKey) {
        New-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force | Out-Null
        Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for User."
    }

    # http://techrena.net/disable-ie-set-up-first-run-welcome-screen/
    $key = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
    if (Test-Path $key) {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1 -PropertyType "DWord" -Force | Out-Null
        Write-Output "IE first run welcome screen has been disabled."
    }
}

Write-Output 'Setting Windows Update service to Manual startup type.'
Set-Service -Name wuauserv -StartupType Manual

# Ensure there is a profile file so we can get tab completion
New-Item -ItemType Directory $(Split-Path $profile -Parent) -Force
Set-Content -Path $profile -Encoding UTF8 -Value "" -Force

winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

# Server Core does not have Explorer.exe
if ([bool](Get-Command -Name 'explorer.exe'  -ErrorAction SilentlyContinue)) {
    # Set Explorer Preferences
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $advancedKey = "$key\Advanced"
    Set-ItemProperty $advancedKey Hidden 1
    Set-ItemProperty $advancedKey HideFileExt 0
    Set-ItemProperty $advancedKey ShowSuperHidden 1

    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $parts = $identity.Name -split "\\"
    $user = @{Domain = $parts[0]; Name = $parts[1]}

    try {
        try { $explorer = Get-Process -Name explorer -ErrorAction stop -IncludeUserName }
        catch {$global:error.RemoveAt(0)}

        if ($explorer -ne $null) {
            $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force -ErrorAction Stop | Out-Null
        }

        Start-Sleep 1

        if (!(Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
            $global:error.RemoveAt(0)
            start-Process -FilePath explorer
        }
    }
    catch {$global:error.RemoveAt(0)}
}

# Enable Network Discovery and File and Print Sharing
# Taken from here: http://win10server2016.com/enable-network-discovery-in-windows-10-creator-edition-without-using-the-netsh-command-in-powershell

Write-Host "Enabling Network Discovery."
try {
    $null = Get-NetFirewallRule -DisplayGroup 'Network Discovery' -ErrorAction Stop | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru -ErrorAction Stop
}
catch {
    Write-Warning "Could not enable Network Discovery."
}

Write-Host "Enabling File and Printer Sharing."
try {
    $null = Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' -ErrorAction Stop | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru -ErrorAction Stop
}
catch {
    Write-Warning "Could not enable File and Printer Sharing."
}

Write-Host 'Setting interfaces to private network type.'
try {
    Get-NetAdapter | ForEach-Object {
        Write-Host "Setting '$($_.Name)' interface to a 'Private' network."
        Get-NetConnectionProfile -InterfaceIndex $_.ifIndex -ErrorAction Stop | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction Stop
    }
}
catch {
    Write-Warning "Unable to set interface."
}

# Only for Server OS with ServerManager
if ([bool](get-Command -Name 'servermanager.exe' -ErrorAction SilentlyContinue) -and $osData.ProductType -eq 3) {
    Write-Host 'Disabling Server Manager for starting at login.'
    Get-ScheduledTask -TaskName 'ServerManager' | Disable-ScheduledTask | Out-Null
}