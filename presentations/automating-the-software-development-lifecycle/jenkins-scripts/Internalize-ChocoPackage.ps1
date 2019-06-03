[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string[]]
    $Name,

    [ValidateScript( { Test-Path $_ })]
    [string]
    $OutputDirectory = (Join-Path -Path $env:SystemDrive -ChildPath "jenkins-packages"),

    [Version]
    $Version,

    [switch]
    $Force
)

function Test-PackageExist ($Name, $Version, $PackagePath) {
    if ($Version) {
        $Name += ".$Version"
    }
    else {
        $Name += ".*"
    }

    $Name += ".nupkg"

    Test-Path -Path (Join-Path -Path $PackagePath -ChildPath $Name)
}

# start from a clean slate
if (Test-Path -Path $OutputDirectory) {
    Remove-Item -Path $OutputDirectory -Force -Recurse
}
New-Item -Path $OutputDirectory -ItemType Directory -Force

$params = "--internalize --internalize-all-urls --append-use-original-location --source=""'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/'"" --no-progress --limitoutput"
$Name | ForEach-Object {
    if ($Force.IsPresent -or (-not (Test-PackageExist -Name $_ -Version $Version -PackagePath $OutputDirectory))) {
#    if ($Force.IsPresent -or (-not (Test-Path -Path (Join-Path -Path $OutputDirectory -ChildPath "$_.*.nupkg")))) {
        Write-Host "Internalizing package '$_' from the Chocolatey Community Repository." -ForegroundColor Green
        $cmd = "choco download $_ --output-directory=$OutputDirectory $params "
        if ($Force.IsPresent) {
            $cmd += "--force "
        }
        Write-Verbose "Running '$cmd'."
        Invoke-Expression -Command $cmd
    }
    else {
        Write-Warning "Skipping internalizing package '$_' as it already exists in '$OutputDirectory'."
        Write-Warning "To internalize this package anyway, use the -Force parameter."
    }
}

# Jenkins Job Code
# node {
#     powershell '''
#         Set-Location (Join-Path -Path $env:SystemDrive -ChildPath 'scripts')
#          $temp = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid
#          New-Item -Path $temp -ItemType Directory | Out-Null
#          Write-Output "Created temporary directory '$temp'."
         
#         .\\Internalize-ChocoPackage.ps1 `
#             -Name $env:P_PKG_LIST `
#             -OutputDirectory $temp `
#             -Verbose
        
#         if ($LASTEXITCODE -eq 0) {
#             Set-Location -Path $temp
#             Get-ChildItem -Path *.nupkg | ForEach-Object {
#                 choco push $_.Name --source=$env:P_DST_URL --apikey=$env:P_API_KEY --limitoutput
#             }
#         }    '''
# }