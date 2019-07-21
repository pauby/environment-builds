if (-not (test-path 'c:\vagrant\reboot.flag')) {
    New-item 'c:\vagrant\reboot.flag' -ItemType file
    Invoke-Reboot
}

choco install putty