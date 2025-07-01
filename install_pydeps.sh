BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
curl -fsSL https://raw.githubusercontent.com/Notho-freedom/PyDeps/master/deps.ps1 -o "$BIN_DIR/deps"
chmod +x "$BIN_DIR/deps"

# Vérifier si $BIN_DIR est dans le PATH
if ! echo $PATH | grep -q "$BIN_DIR"; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.bashrc
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.zshrc
    echo "✅ $BIN_DIR ajouté au PATH. Relance ton shell."
fi
