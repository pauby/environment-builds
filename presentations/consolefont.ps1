<#
.SYNOPSIS
    Sets the console settings to the specified values and color theme.
.DESCRIPTION
    Sets the console settings to the specified values and color theme.
.EXAMPLE
    C:\PS> Configure-ConsoleSettings -Theme ConEmu -WindowSize 120,50 `
                                     -FontFace Consolas -FontSize 12

    Sets the colors to those used in ConEmu and sets the font and window size.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    # Specify a color theme to choose from.
    [Parameter(Mandatory)]
    [ValidateSet('Default', 'ConEmu')]
    [string]
    $Theme,

    # Specify the PowerShell arhitecture (x64 or x86). The default is x64.
    [Parameter()]
    [ValidateSet('x86', 'x64')]
    [string]
    $Architecture = 'x64',

    # Specify the font face.
    [Parameter()]
    [string]
    $FontFace = 'Consolas',

    # Specify the font size.
    [Parameter()]
    [ValidateRange(5, 72)]
    [string]
    $FontSize,

    # If specified, makes the font bold.
    [Parameter()]
    [switch]
    $BoldFont,

    # Specify the window size e.g. -WindowSize 120,50
    [Parameter()]
    [int[]]
    $WindowSize,

    # Specify the window's opacity in percentage 90 for 90%. Default is 100%
    [Parameter()]
    [ValidateRange(30, 100)]
    [int]
    $Opacity = 100
)

begin {
    $themes = @{
        Default = @{
            BackgroundIndex = 0
            ForegroundIndex = 7
            ColorTable00 = 0x00000000 # Black
            ColorTable01 = 0x00800000 # DarkBlue
            ColorTable02 = 0x00008000 # DarkGreen
            ColorTable03 = 0x00808000 # DarkCyan
            ColorTable04 = 0x00000080 # DarkRed
            ColorTable05 = 0x00800080 # DarkMagenta
            ColorTable06 = 0x00008080 # DarkYellow
            ColorTable07 = 0x00C0C0C0 # Gray
            ColorTable08 = 0x00808080 # DarkGray
            ColorTable09 = 0x00FF0000 # Blue
            ColorTable10 = 0x0000FF00 # Green
            ColorTable11 = 0x00FFFF00 # Cyan
            ColorTable12 = 0x000000FF # Red
            ColorTable13 = 0x00FF00FF # Magenta
            ColorTable14 = 0X0000FFFF # Yellow
            ColorTable15 = 0x00FFFFFF # White
        }
        ConEmu = @{
            BackgroundIndex = 0
            ForegroundIndex = 7
            ColorTable00 = 0x00201700 # updated - Black
            ColorTable01 = 0x00800000
            ColorTable02 = 0x00008000
            ColorTable03 = 0x00A0A000 # udpated - lightened up DarkCyan
            ColorTable04 = 0x000000C0
            ColorTable05 = 0x00800080
            ColorTable06 = 0x00396070 # updated - DarkYellow
            ColorTable07 = 0x00C0C0C0
            ColorTable08 = 0x007D7C6F # updated - DarkGray
            ColorTable09 = 0x00FF0000
            ColorTable10 = 0x0000FF00
            ColorTable11 = 0x00FFFF00
            ColorTable12 = 0x000000c0
            ColorTable13 = 0x00FF00FF
            ColorTable14 = 0x0080CAE8 # updated - Yellow
            ColorTable15 = 0x00FFFFFF
        }
    }

    function MakeByte([ValidateRange(0,15)][int]$bgIndex, [ValidateRange(0,15)][int]$fgIndex) {
        ($bgIndex -shl 4) + $fgIndex
    }

    function MakeDword($left, $right) {
        ($left -shl 16) + $right
    }
}

end {
    $regKey = 'HKCU:\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe'
    if ($Architecture -eq 'x86') {
        $regKey = 'HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'
    }

    #Remove-Item $regKey -EA SilentlyContinue
    if (!(Test-Path $regKey)) {
        New-Item $regKey > $null
    }

    if ($PSCmdlet.ShouldProcess($regKey, "Applying theme $Theme")) {
        foreach ($kvPair in $themes[$Theme].GetEnumerator()) {
            if ($kvPair.Key -notmatch 'ColorTable\d\d') {
                continue
            }

            $PSCmdlet.WriteVerbose("Setting $($kvPair.Key) to $('0x{0:X8}' -f $kvPair.Value)")
            New-ItemProperty -Path $regKey -Name $kvPair.Key -Type DWORD -Value $kvPair.Value -Force > $null
        }
    }

    if ($PSCmdlet.ShouldProcess('', "Setting fonts, buffer, screen size, etc")) {
        New-ItemProperty $regKey FaceName      -Type STRING -Value $FontFace  -Force > $null
        New-ItemProperty $regKey FontFamily    -Type DWORD  -Value 0x00000036 -Force > $null
        New-ItemProperty $regKey FontWeight    -Type DWORD  -Value 0x00000190 -Force > $null
        New-ItemProperty $regKey HistoryNoDup  -Type DWORD  -Value 0x00000000 -Force > $null
        New-ItemProperty $regKey QuickEdit     -Type DWORD  -Value 0x00000001 -Force > $null
        New-ItemProperty $regKey FilterOnPaste -Type DWORD  -Value 0x00000001 -Force > $null
        New-ItemProperty $regKey LineSelection -Type DWORD  -Value 0x00000001 -Force > $null

        $screenColors = MakeByte $themes[$Theme].BackgroundIndex $themes[$Theme].ForegroundIndex
        New-ItemProperty $regKey ScreenColors -Type DWORD -Value $screenColors -Force > $null

        if ($WindowSize) {
            $windowSz = MakeDword $WindowSize[1] $WindowSize[0]
            $bufferSz = MakeDword 9999 $WindowSize[0]
            New-ItemProperty $regKey ScreenBufferSize -type DWORD -value $bufferSz -Force > $null
            New-ItemProperty $regKey WindowSize -type DWORD -value $windowSz -Force > $null
        }

        if ($FontSize) {
            $fontSz = MakeDword $FontSize 0
            New-ItemProperty $regKey FontSize -type DWORD -value $fontSz -Force > $null
        }

        $fontWeight = MakeDword 0 0x190
        if ($BoldFont) {
            $fontWeight = MakeDword 0 0x2bc
        }
        New-ItemProperty $regKey FontWeight -type DWORD -value $fontWeight -Force > $null

        $opacityVal = MakeDword 0 ([Math]::Ceiling(($Opacity / 100.0) * 256))
        New-ItemProperty $regKey WindowAlpha -type DWORD -value $opacityVal -Force > $null
    }
}
