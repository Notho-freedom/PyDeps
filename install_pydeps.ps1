# Crée un dossier bin si pas déjà présent
$binDir = "$HOME\bin"
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

# Télécharger deps.ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Notho-freedom/PyDeps/master/deps.ps1" -OutFile "$binDir\deps.ps1"

# Ajouter binDir au PATH si nécessaire
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $oldPath.Split(";") -contains $binDir) {
    $newPath = "$oldPath;$binDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Output "✅ $binDir ajouté au PATH. Relance ta session PowerShell."
} else {
    Write-Output "✅ $binDir est déjà dans le PATH."
}
