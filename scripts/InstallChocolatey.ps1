# From https://chocolatey.org/install
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Update-SessionEnvironment
choco feature enable --name="'autouninstaller'"
# - not recommended for production systems:
choco feature enable --name="'allowGlobalConfirmation'"
# - not recommended for production systems:
choco feature enable --name="'logEnvironmentValues'"

# Set Configuration
choco config set cacheLocation $env:ALLUSERSPROFILE\choco-cache
choco config set commandExecutionTimeoutSeconds 14400

# Sources - Remove community repository
#choco source remove --name="'chocolatey'"

# Sources - Add internal repositories
choco source add --name="'local'" --source="'c:\packages'" --priority="'1'" --bypass-proxy --allow-self-service

# Sources - change priority of community repository
choco source remove --name="'chocolatey'"
choco source add --name='chocolatey' --source='https://chocolatey.org/api/v2/' --priority='2' --bypass-proxy