[CmdletBinding()]
Param (
    [ValidateNotNull()]
    [string]
    $ConfigurationPath
)

function Start-WaitForJenkinsToStart {
    [CmdletBinding()]
    Param (
        [int]
        $WaitSeconds = 60
    )

    # loop either $WaitSeconds times or until we get a 403 status code response (403 means we
    # are unauthorised and the service is therefore up)
    $status = 0
    for ($i = 0; $i -lt $WaitSeconds -and $status -ne 403; $i++) {
        Start-Sleep -Seconds 1
        try {
            $request = $null
            $request = Invoke-WebRequest -Uri 'http://localhost:8080' -UseBasicParsing
        }
        catch {
            $request = $_.exception.response
        }
        $status = [int]$request.StatusCode
    }

    $i
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
choco upgrade jenkins --version 2.164.3 -y --no-progress
choco pin add -n=jenkins

$maxSecondsToWait = 60
Write-Host "Waiting up to $maxSecondsToWait seconds for Jenkins to start."
$waitedSeconds = Start-WaitForJenkinsToStart -WaitSeconds $maxSecondsToWait
# check how long we waited
if ($waitedSeconds -ge $maxSecondsToWait) {
    Write-Error "Timed out waiting $maxSecondsToWait seconds for Jenkins to restart." -ErrorAction Stop
}

Write-Host "Stopping Jenkins service."
Stop-Service -Name jenkins

if (-not [string]::IsNullOrEmpty($ConfigurationPath) -and (Test-Path -Path $ConfigurationPath)) {
    choco upgrade 7zip.install -y --no-progress
    Write-Host "Extracting Jenkins configuration files..."
    7z.exe x $ConfigurationPath -y -r -bd -o"c:\program files (x86)\jenkins"
    Write-Host "Finished extracting config files."
}

Write-Host "Starting Jenkins service."
Start-Service -Name Jenkins
Write-Host "Waiting up to $maxSecondsToWait seconds for Jenkins to respond."
$waitedSeconds = Start-WaitForJenkinsToStart -WaitSeconds $maxSecondsToWait

# check how long we waited
if ($waitedSeconds -ge $maxSecondsToWait) {
    Write-Error "Timed out waiting 60 seconds for Jenkins to restart."
}
else {
    Write-Host "Waited $waitedSeconds seconds for Jenkins to restart."

    $pw = Get-Content "c:\program files (x86)\jenkins\secrets\initialAdminPassword"
    Set-Location "c:\program files (x86)\jenkins\jre\bin"

    Write-Host "Installing Jenkins plugins."
    "build-token-root", "build-timeout", "workflow-aggregator", "pipeline-stage-view", "powershell" | ForEach-Object {
        # Just wait an extra 5 seconds to be sure
        Start-Sleep -Seconds 5
        Write-Host "Installing plugin '$_'"
        .\java.exe -jar ..\..\war\web-inf\jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$pw install-plugin $_
    }

    Write-Host "Restarting Jenkins service."
    Restart-Service -Name jenkins
}

# put the secrets file containing the password onto the desktop
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\\Desktop\\Jenkins Password.lnk")
$Shortcut.Arguments = "c:\\Program Files (x86)\\Jenkins\\secrets\\initialAdminPassword"
$Shortcut.TargetPath = "c:\\windows\\notepad.exe"
$Shortcut.Save()