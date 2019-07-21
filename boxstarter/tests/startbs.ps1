Remove-Item -Path 'c:\vagrant\reboot.flag' -ErrorAction SilentlyContinue
$secpasswd = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("vagrant", $secpasswd)
Install-BoxstarterPackage -PackageName c:\vagrant\tests\boxstarter-test.ps1 -Credential $mycreds