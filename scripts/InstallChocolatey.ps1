[CmdletBinding()]
Param (
    [switch]
    $UseLocalSource
)

# From https://chocolatey.org/install
$installScript = Join-Path -Path $env:TEMP -ChildPath "$(([GUID]::NewGuid()).Guid.ToString()).ps1"
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing -OutFile $installScript
& $installScript

#Update-SessionEnvironment
choco feature enable --name="'autouninstaller'"
# - not recommended for production systems:
choco feature enable --name="'allowGlobalConfirmation'"
# - not recommended for production systems:
choco feature enable --name="'logEnvironmentValues'"

# Set Configuration
choco config set cacheLocation $env:ALLUSERSPROFILE\choco-cache
choco config set commandExecutionTimeoutSeconds 14400

if ($UseLocalSource.IsPresent) {
    Write-Output "Using local \packages folder as priority 1 install location."
    # Sources - Add internal repositories
    choco source add --name="'local'" --source="'\packages'" --priority="'1'" --bypass-proxy --allow-self-service

    # Sources - change priority of community repository
    Write-Output "Using Chocolatey Community Repository as priority 2 install location."
    choco source remove --name="'chocolatey'"
    choco source add --name='chocolatey' --source='https://chocolatey.org/api/v2/' --priority='2' --bypass-proxy
}

# Notify Gui apps of environment change
# because sometimes explorer.exe just doesn't get the message that things were updated.
if (-not ("win32.nativemethods" -as [type])) {
    # import sendmessagetimeout from win32
    add-type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(
  IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
  uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
}

$HWND_BROADCAST = [intptr]0xffff;
$WM_SETTINGCHANGE = 0x1a;
$result = [uintptr]::zero

# notify all windows of environment block change
[win32.nativemethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [uintptr]::Zero, "Environment", 2, 5000, [ref]$result);

# Attempting to make the script recapture environment changes
setx.exe trigger 1

#Write-Output "For good measure, we are going to take out explorer"
#tskill.exe explorer /a /v