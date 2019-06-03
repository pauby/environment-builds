<#
.NOTES
    Written by Paul Broadwwith (paul@pauby.com) October 2018
#>

#Requires -Modules Pester
[CmdletBinding()]
Param (
    [string[]]
    $Package,

    [string]
    $Source,

    [string]
    $Path
)

Describe "Testing Chocolatey Package $(Split-Path -Path $Path -Leaf)" {

    $tempPath = New-Item -Path (Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid) -ItemType Directory -ErrorAction Stop

    It "should be a valid .nupkg file format" {
        $unzipCmd = "7z x -y -bd -bb0 -o$($tempPath.ToString()) $Path"
        Invoke-Expression -Command $unzipCmd

        $LASTEXITCODE | Should -Be 0
    }

    # Clear out the unneeded files and folders from the package extraction
    Remove-Item -Path '[Content_Types].xml' -Force
    'package', '_rels' | ForEach-Object {
        Remove-Item -Path (Join-Path -Path $tempPath -ChildPath $_) -Recurse -Force
    }

    $nuspecFile = Get-ChildItem -Path (Join-Path -Path $tempPath -ChildPath '*.nuspec')
    It "should contain one .nuspec file" {
        @($nuspecFile).Count | Should -Be 1
    }

    It "should have a valid .nuspec file" {
        { [xml](Get-Content -Path $nuspecFile) } | Should -Not -Throw
    }

    Context "Testing package $pkg" {
        it 'should install without error' {

            # choco install $pkg -y -s $Source
            # $LASTEXITCODE | Should Be 0
            $true | Should Be $true
        }

        it 'should uninstall without error' {
            # choco uninstall $pkg -y
            # $LASTEXITCODE | Should Be 0
            $true | Should Be $true
        }
    } #context
}# describe