# only install these apps on an operating system that has Explorer (ie. not Server Core)
if ([bool](Get-Command -Name 'explorer.exe' -ErrorAction SilentlyContinue)) {
    choco upgrade baretail, dotnetversiondetector, notepadplusplus.install -y
}

# install in all environments
choco upgrade 7zip, git -y