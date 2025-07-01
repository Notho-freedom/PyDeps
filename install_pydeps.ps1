# Variables
$repo = "Notho-freedom/PyDeps"
$scriptName = "pyDeps.py"
$rawUrl = "https://raw.githubusercontent.com/$repo/master/$scriptName"
$binDir = "$HOME\bin"

Write-Output "➡️ Installation de PyDeps..."

# Crée le dossier s'il n'existe pas
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
    Write-Output "✅ Dossier $binDir créé."
}

# Télécharge le script
Invoke-WebRequest -Uri $rawUrl -OutFile "$binDir\pydeps.py"
Write-Output "✅ Script téléchargé dans $binDir\pydeps.py"

# Ajout du dossier au PATH utilisateur s'il n'y est pas déjà
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $oldPath.Split(";") -contains $binDir) {
    $newPath = "$oldPath;$binDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Output "✅ $binDir ajouté à la variable PATH utilisateur. Relance ta session PowerShell."
} else {
    Write-Output "✅ $binDir est déjà dans la variable PATH."
}

Write-Output ""
Write-Output "✅ Installation terminée ! Tu peux maintenant exécuter le script ainsi :"
Write-Output "    python $binDir\pydeps.py"
