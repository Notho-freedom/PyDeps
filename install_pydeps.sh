#!/bin/bash

# Variables
REPO="Notho-freedom/PyDeps"
SCRIPT_NAME="pyDeps.py"
RAW_URL="https://raw.githubusercontent.com/$REPO/master/$SCRIPT_NAME"
BIN_DIR="$HOME/.local/bin"

echo "➡️ Installation de PyDeps..."

# Création du dossier si inexistant
mkdir -p "$BIN_DIR"

# Téléchargement du script
curl -fsSL "$RAW_URL" -o "$BIN_DIR/pydeps"
chmod +x "$BIN_DIR/pydeps"

# Vérifie si le dossier est déjà dans le PATH
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.zshrc"
    echo "✅ PATH ajouté à .bashrc et .zshrc"
else
    echo "✅ $BIN_DIR est déjà dans le PATH."
fi

echo ""
echo "✅ Installation terminée ! Relance ton terminal ou exécute :"
echo "    source ~/.bashrc"
echo ""
echo "Tu peux maintenant utiliser la commande : pydeps"
