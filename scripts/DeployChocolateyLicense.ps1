$licenseFileSourcePath = 'C:\license\bus-chocolatey.license.xml'
$licenseDestinationPath = 'C:\ProgramData\chocolatey\license\chocolatey.license.xml'

If (-Not (Test-Path $licenseDestinationPath)) {
  New-Item -ItemType Directory -Path $licenseDestinationPath
}

If (-Not (Test-Path $licenseFileSourcePath)) {
  Throw "License File has not been copied to $licenseFileSourcePath. Place manually now."
  Exit 1
}

Copy-Item -Path $licenseFileSourcePath -Destination $licenseDestinationPath -Force
