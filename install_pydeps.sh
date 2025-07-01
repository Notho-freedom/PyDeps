#!/bin/bash

# Configuration
REPO="Notho-freedom/PyDeps"
SCRIPT_NAME="pyDeps.py"
RAW_URL="https://raw.githubusercontent.com/$REPO/master/$SCRIPT_NAME"
BIN_DIR="$HOME/.local/bin"

# Crée le dossier s'il n'existe pas
mkdir -p "$BIN_DIR"

# Télécharge le script
echo "➡️ Téléchargement de pyDeps.py..."
curl -fsSL "$RAW_URL" -o "$BIN_DIR/pydeps"
chmod +x "$BIN_DIR/pydeps"

# Ajoute BIN_DIR au PATH si absent
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
  echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
  echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.zshrc"
  echo "✅ PATH mis à jour dans .bashrc et .zshrc"
fi

echo "✅ Installation terminée. Relance ton terminal ou exécute :"
echo "    source ~/.bashrc"
echo ""
echo "Tu peux maintenant exécuter : pydeps"
