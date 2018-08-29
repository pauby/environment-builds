
@( 'baretail', 'dotnetversiondetector', 'notepadplusplus.install', '7zip' ) | ForEach-Object {
    choco upgrade $_ -y --no-progress
}