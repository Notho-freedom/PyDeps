$repo = "Notho-freedom/PyDeps"
$scriptName = "pyDeps.py"
$rawUrl = "https://github.com/$repo/master/$scriptName"
$binDir = "$HOME\bin"

# Crée le dossier s'il n'existe pas
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

# Télécharge le script
Write-Output "➡️ Téléchargement de pyDeps.py..."
Invoke-WebRequest -Uri $rawUrl -OutFile "$binDir\pydeps.py"

# Ajoute le dossier au PATH utilisateur si absent
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $oldPath.Split(";") -contains $binDir) {
    $newPath = "$oldPath;$binDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Output "✅ $binDir ajouté à la variable PATH utilisateur. Relance ta session PowerShell."
} else {
    Write-Output "✅ $binDir est déjà dans la variable PATH."
}

Write-Output "✅ Installation terminée. Tu peux maintenant exécuter le script ainsi :"
Write-Output "    python $binDir\pydeps.py"
