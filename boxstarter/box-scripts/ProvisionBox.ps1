# Running the one script instead of each one of the scripts below, individually
# as a separate provisioner in the Vagrantfile, is a lot quicker!

# Sometimes the synced folders are not available when it gets to this
# script so just wait up to 30 seconds for it
if (-not (Test-Path -Path 'c:\shell')) {
    $loops = 6
    $delay = 5

    Write-Host ('Waiting up to {0} seconds for shell path to become available ' -f $loops * $delay) -NoNewline
    for ($i = 0; $i -lt $loops-1; $i++) {
        Write-Host "." -NoNewline
        if (Test-Path -Path 'c:\shell') {
            break
        }
    }

    # if we finish the loops and never get a connection then it's fine because
    # the below will fail anyway - saves writing code to detect it!
}

c:\shell\PrepareWindows.ps1 -CleanupWindows10
# left the below in to remind us that we want Boxstarter to do this bit
#.\shell\ConfigureAutoLogin.ps1
c:\shell\InstallVMGuestTools.ps1
# Boxstarter doesn't use a local source so lets just not configure one.
c:\shell\InstallChocolatey.ps1 #-UseLocalSource
c:\shell\InstallChocoPackage.ps1 -Name 7zip.install, notepadplusplus.install, baretail -UseLocalSource
c:\vagrant\box-scripts\Install-Boxstarter.ps1