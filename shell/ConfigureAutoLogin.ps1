[CmdletBinding(DefaultParameterSetName = 'Enable')]
Param (
    [Parameter(ParameterSetName = 'Enable')]
    [switch]
    $Enable,

    [Parameter(ParameterSetName = 'Disable')]
    [switch]
    $Disable
)

if ($PSCmdlet.ParameterSetName -eq "Enable") {
    # Auto Login issue corrected, as per discussion here: https://twitter.com/stefscherer/status/1011120268222304256
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1 -ErrorAction SilentlyContinue
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "vagrant" -ErrorAction SilentlyContinue
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "vagrant" -ErrorAction SilentlyContinue
    Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogonCount -Confirm -ErrorAction SilentlyContinue
}
else {
    Write-Verbose "Disabling Autologon..."
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0 -ErrorAction SilentlyContinue
    Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogonCount -Confirm -ErrorAction SilentlyContinue
}