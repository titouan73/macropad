# Fonction pour obtenir le scancode d'une touche
function Get-ScanCode {
    try {
        while ($true) {
            $key = [System.Console]::ReadKey()
            $scanCode = $key.Key.GetHashCode()
            Write-Host "Scan Code: $scanCode"
        }
    } catch {
        # Gérer l'événement Ctrl-C
        Write-Host "Arrêt du script suite à l'appui sur Ctrl-C."
    }
}

# Appeler la fonction pour obtenir le scancode
Get-ScanCode
