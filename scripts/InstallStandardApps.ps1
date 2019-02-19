# only install these apps on an operating system that has Explorer (ie. not Server Core)
if ([bool](Get-Command -Name 'explorer.exe' -ErrorAction SilentlyContinue)) {
    & \scripts\InstallChocoPackage.ps1 -Package @( 'baretail', 'dotnetversiondetector', 'notepadplusplus.install' )
}

# if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
#     Write-Warning "Chocolatey not installed. Cannot install standard packages."
# }
# else {
#     @( 'baretail', 'dotnetversiondetector', 'notepadplusplus.install', '7zip' ) | ForEach-Object {
#         choco upgrade $_ -y --no-progress
#     }
# }

# install in all environments
& \scripts\InstallChocoPackage.ps1 -Package @( '7zip', 'git' )