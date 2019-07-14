choco upgrade bginfo

Copy-Item "\shell\bginfo.bgi" 'C:\programdata\chocolatey\lib\bginfo\tools\bginfo.bgi'
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value 'c:\programdata\chocolatey\lib\bginfo\tools\bginfo.exe C:\programdata\chocolatey\lib\bginfo\tools\bginfo.bgi /accepteula /silent /timer:0'