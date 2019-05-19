[CmdletBinding()]
Param (
    [string]
    $Region = "UK"
)

# This script is based on https://www.lewisroberts.com/2017/03/01/set-language-culture-timezone-using-powershell/
# To create code for a new culture see https://msdn.microsoft.com/en-us/goglobal/bb964650
switch ($Region) {
    "UK" {
        $timezone = "GMT Standard Time"
        $culture = "en-GB"
    }
}

# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"Region-$Region.xml`""

# These would be nice but they don't affect the default user account, so are pretty pointless.
#Set-WinSystemLocale -SystemLocale en-GB
#Set-WinHomeLocation -GeoId 242
#Set-WinUserLanguageList -LanguageList (New-WinUserLanguageList -Language en-GB) -Force

# Set Timezone
& tzutil /s $timezone

# Set languages/culture
Set-Culture $culture # This one works!