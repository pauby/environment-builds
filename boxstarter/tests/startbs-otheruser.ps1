Remove-Item -Path 'c:\vagrant\reboot.flag' -ErrorAction SilentlyContinue
$secpasswd = ConvertTo-SecureString "Password01" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("bslogin", $secpasswd)
Install-BoxstarterPackage -PackageName c:\vagrant\tests\boxstarter-test.ps1 -Credential $mycreds