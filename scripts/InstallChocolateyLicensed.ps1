choco upgrade chocolatey.extension -y --source="'c:\packages'" --pre

#choco feature enable --name="'virusCheck'"
choco feature enable --name="'allowPreviewFeatures'"
choco feature enable --name="'internalizeAppendUseOriginalLocation'"
choco feature enable --name="'reduceInstalledPackageSpaceUsage'"
choco feature disable --name="'showNonElevatedWarnings'"