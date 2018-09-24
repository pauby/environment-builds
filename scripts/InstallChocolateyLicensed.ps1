$licenseFileSourcePath = 'C:\license\bus-chocolatey.license.xml'
$licenseDestinationPath = 'C:\ProgramData\chocolatey\license\chocolatey.license.xml'

$path = Split-Path -Path $licenseDestinationPath -Parent
If (-Not (Test-Path -Path $path)) {
  New-Item -ItemType Directory -Path $path
}

If (-Not (Test-Path $licenseFileSourcePath)) {
  Throw "License File has not been copied to $licenseFileSourcePath. Place manually now."
  Exit 1
}

Copy-Item -Path $licenseFileSourcePath -Destination $licenseDestinationPath -Force

choco upgrade chocolatey.extension -y --source="'c:\packages'" --pre

#choco feature enable --name="'virusCheck'"
choco feature enable --name="'allowPreviewFeatures'"
choco feature enable --name="'internalizeAppendUseOriginalLocation'"
choco feature enable --name="'reduceInstalledPackageSpaceUsage'"
choco feature disable --name="'showNonElevatedWarnings'"