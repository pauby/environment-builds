# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
#. \box-scripts\boxstarter-bootstrapper.ps1 | iex; get-boxstarter -Force
#choco source add --name="'local'" --source="'$env:SystemDrive\packages'" --priority="'10'" --bypass-proxy --allow-self-service

choco install boxstarter -y

# the stuff below may be needed for Virtualbox but Hyper-V seems to kee the synced folders after reboot

# we need to replace the Restart-Computer cmdlet with a function that will allow vagrant to execute vagrant reload
# $scriptCode = @'
# Resolve-Path $PSScriptRoot\*.ps1 |
#     % { . $_.ProviderPath }

# Export-ModuleMember Confirm-Choice,`
#                     Create-BoxstarterTask,`
#                     Enter-BoxstarterLogable,`
#                     Enter-DotNet4,`
#                     Get-CurrentUser,`
#                     Get-HttpResource,`
#                     Get-IsMicrosoftUpdateEnabled,`
#                     Get-IsRemote,`
#                     Invoke-FromTask,`
#                     Invoke-RetriableScript,`
#                     Out-BoxstarterLog,`
#                     Log-BoxstarterMessage,`
#                     Remove-BoxstarterError,`
#                     Remove-BoxstarterTask,`
#                     Start-TimedSection,`
#                     Stop-TimedSection,`
#                     Test-Admin,`
#                     Write-BoxstarterLogo,`
#                     Restart-Computer,`
#                     Write-BoxstarterMessage

# Export-ModuleMember -Variable Boxstarter
# '@
# Set-Content -Path 'c:\programdata\boxstarter\boxstarter.common\boxstarter.common.psm1' -Value $scriptCode -Force
# Copy-Item -Path 'C:\box-scripts\Injected-Restart-Computer.ps1' -Destination 'c:\programdata\boxstarter\boxstarter.common\' -Force
