
@( 'baretail', 'dotnetversiondetector', 'notepadplusplus.install' ) | ForEach-Object {
    choco upgrade $_ -y
}