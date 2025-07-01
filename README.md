````markdown
# PyDeps

🚀 **PyDeps** est un outil Python qui scanne ton projet, détecte les imports utilisés, identifie les dépendances manquantes et les installe automatiquement. Il peut aussi générer un `requirements.txt` et un Dockerfile minimaliste pour dockeriser ton projet en un clic.

> 🛠️ **Cross-plateforme :** fonctionne sous Linux, macOS et Windows.

---

## ✨ Fonctionnalités

✅ Scanne tous les fichiers `.py` dans ton projet (récursivement)  
✅ Identifie tous les imports utilisés  
✅ Ignore les modules natifs de Python  
✅ Détecte les modules manquants non installés  
✅ Installe automatiquement les dépendances manquantes via `pip`  
✅ Peut tout faire en mode automatique via une seule commande  
✅ Génère un fichier `requirements.txt`  
✅ Génère un Dockerfile minimaliste pour dockeriser ton projet  
✅ Mise à jour automatique de `pip` au lancement  
✅ Utilisation simple depuis un shell (bash, zsh, PowerShell)

---

## 🚀 Installation rapide

### Linux / macOS

**One-liner :**

```bash
curl -fsSL https://raw.githubusercontent.com/Notho-freedom/PyDeps/master/install_pydeps.sh | bash
````

**Ou en local :**

```bash
git clone https://github.com/Notho-freedom/PyDeps.git
cd PyDeps
chmod +x install_pydeps.sh
./install_pydeps.sh
```

### Windows (PowerShell)

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/Notho-freedom/PyDeps/master/install_pydeps.ps1 -OutFile install_pydeps.ps1
.\install_pydeps.ps1
```

> ⚠️ Sous Windows, relance ta session PowerShell ou ton terminal après installation pour que le PATH soit pris en compte.

---

## ✅ Après installation

Si l’installation s’est bien passée :

* **Linux / macOS :**

  ```bash
  pydeps
  ```

* **Windows :**

  ```powershell
  python $HOME\bin\pydeps.py
  ```

---

## 🎯 Utilisation

### Lancer PyDeps manuellement

```bash
pydeps [chemin/vers/projet]
```

* Si tu ne donnes pas de chemin → il scanne le dossier courant.
* Sinon, indique un chemin vers ton projet Python.

---

### Mode automatique

Tu peux tout lancer en une seule commande :

```bash
pydeps --auto
```

Cela va :

* mettre à jour pip
* détecter les imports utilisés
* installer les paquets manquants
* mettre à jour les paquets obsolètes
* faire un audit de sécurité
* générer `requirements.txt`
* générer un Dockerfile

---

## 🐳 Génération automatique du Dockerfile

Si tu souhaites dockeriser ton projet, PyDeps peut générer un Dockerfile minimaliste :

```bash
pydeps --docker
```

Cela créera un fichier `Dockerfile` dans ton dossier projet avec :

```Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY . /app

RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt

CMD ["python"]
```

---

## 📄 Génération de requirements.txt

Pour figer tes dépendances dans un fichier `requirements.txt` :

```bash
pydeps --export
```

---

## 🌐 Mise à jour

Tu souhaites mettre PyDeps à jour ? Relance simplement le script d’installation.

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/Notho-freedom/PyDeps/master/install_pydeps.sh | bash
```

### Windows (PowerShell)

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/Notho-freedom/PyDeps/master/install_pydeps.ps1 -OutFile install_pydeps.ps1
.\install_pydeps.ps1
```

---

## ❓ FAQ

### ➡️ Dois-je avoir Python déjà installé ?

✅ Oui. PyDeps tourne en Python 3.x minimum.

---

### ➡️ Est-ce que ça marche sous Windows ?

✅ Oui, via PowerShell.

---

### ➡️ Est-ce que ça marche sous Linux / macOS ?

✅ Oui, via Bash ou Zsh.

---

### ➡️ Puis-je l’exécuter depuis n’importe où ?

✅ Oui, grâce à l’ajout automatique du script dans ton PATH lors de l’installation.

---

### ➡️ Est-ce que PyDeps installe les modules internes ?

❌ Non. PyDeps détecte et ignore tous les modules standards/natifs de Python.

---

## 💡 Contribuer

* Fork le repo
* Crée une branche
* Push tes changements
* Ouvre une Pull Request

Toutes les idées ou améliorations sont les bienvenues ! 🚀

---

## 🎉 Auteur

[Notho-freedom](https://github.com/Notho-freedom)

---

## Licence

MIT License

---

**Enjoy !** 🚀

```

---

## 📝 Ce README couvre :

✅ **Installation** (Linux, macOS, Windows)  
✅ **Utilisation manuelle et automatique**  
✅ **Explications fonctionnalités**  
✅ **FAQ**  
✅ **Liens de mise à jour**  
✅ **Dockerfile auto**  
✅ **Contribution**

Prêt à être collé dans ton `README.md` sur GitHub ! Tu souhaites que j’y ajoute autre chose (screenshots, gif animé, jokes…)?
```
