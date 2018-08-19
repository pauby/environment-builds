[CmdletBinding()]
Param (
    [string[]]
    $Apps
)

$Apps | ForEach-Object {
    choco upgrade $_ -y --no-progress
}