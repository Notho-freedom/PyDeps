#!/usr/bin/env pwsh
# deps.ps1

param (
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]] $Args
)

# Définir où stocker le script Python généré
$binDir = "$HOME\bin"
$pyScriptPath = Join-Path $binDir "pydeps.py"

# Créer le dossier si inexistant
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
    Write-Output "✅ Création du dossier $binDir"
}

# Générer le script Python s'il n'existe pas encore
if (-not (Test-Path $pyScriptPath)) {
    Write-Output "➡️ Génération du script Python intégré..."
    
    $pythonCode = @"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import ast
import sys
import subprocess
import json
import sysconfig
import importlib.util
from concurrent.futures import ThreadPoolExecutor, as_completed

try:
    import pip_api
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pip-api"])
    import pip_api

try:
    import pip_audit.api as audit_api
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pip-audit"])
    import pip_audit.api as audit_api

VENV_FOLDER = ".venv"
EXCLUDE_DIRS = {"__pycache__", ".git", VENV_FOLDER}

MODULE_TO_PIP = {
    "PIL": "Pillow",
    "yaml": "PyYAML",
    "sklearn": "scikit-learn",
    "cv2": "opencv-python",
    "Crypto": "pycryptodome",
    "Image": "Pillow",
    "dateutil": "python-dateutil",
}

MAX_THREADS = 8

def colored(text, color):
    colors = {
        "red": "\033[91m", "green": "\033[92m", "yellow": "\033[93m",
        "blue": "\033[94m", "magenta": "\033[95m", "cyan": "\033[96m",
        "white": "\033[97m", "reset": "\033[0m",
    }
    return colors.get(color, colors["reset"]) + text + colors["reset"]

def run_subprocess(cmd):
    subprocess.check_call(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def update_pip():
    print(colored("⬆️ Mise à jour automatique de pip...", "cyan"))
    run_subprocess([sys.executable, "-m", "pip", "install", "--upgrade", "pip"])

def is_builtin(module_name):
    if module_name in sys.builtin_module_names:
        return True
    try:
        spec = importlib.util.find_spec(module_name)
        stdlib_path = sysconfig.get_paths()["stdlib"]
        return spec and spec.origin and spec.origin.startswith(stdlib_path)
    except Exception:
        return False

def extract_imports(filepath):
    try:
        with open(filepath, encoding='utf-8') as f:
            tree = ast.parse(f.read(), filename=filepath)
    except SyntaxError:
        print(colored(f"⚠️ Syntax error in file: {filepath}", "red"))
        return set()
    imports = set()
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                imports.add(alias.name.split('.')[0])
        elif isinstance(node, ast.ImportFrom):
            if node.module:
                imports.add(node.module.split('.')[0])
    return imports

def scan_python_files(directory):
    py_files = []
    for root, dirs, files in os.walk(directory):
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
        for f in files:
            if f.endswith(".py"):
                py_files.append(os.path.join(root, f))
    return py_files

def create_venv():
    if not os.path.isdir(VENV_FOLDER):
        print(colored("⚙️ Creating virtual environment...", "cyan"))
        subprocess.check_call([sys.executable, "-m", "venv", VENV_FOLDER])
    else:
        print(colored(f"✅ Virtual env already exists: {VENV_FOLDER}", "green"))

def map_module_to_pip(mod):
    return MODULE_TO_PIP.get(mod, mod)

def install_package(pkg, upgrade=False):
    python_bin = os.path.join(VENV_FOLDER, "Scripts" if os.name=="nt" else "bin", "python")
    cmd = [python_bin, "-m", "pip", "install", pkg]
    if upgrade:
        cmd.append("--upgrade")
    run_subprocess(cmd)
    print(colored(f"✅ Installed: {pkg}", "green"))

def install_parallel(packages, upgrade=False):
    with ThreadPoolExecutor(max_workers=MAX_THREADS) as executor:
        futures = [executor.submit(install_package, pkg, upgrade) for pkg in packages]
        for _ in as_completed(futures):
            pass

def audit_vulnerabilities():
    print(colored("🔎 Checking vulnerabilities...", "cyan"))
    api = audit_api.PipAuditBuilder().build()
    results = api.audit()
    if not results:
        print(colored("🎉 No vulnerabilities found!", "green"))
    else:
        for vuln in results:
            print(colored(f"⚠️ {vuln.name} {vuln.version} - {vuln.id}: {vuln.fix_versions}", "red"))

def generate_requirements(directory):
    installed = pip_api.installed_distributions(local=True)
    path = os.path.join(directory, "requirements.txt")
    with open(path, "w") as f:
        for dist in sorted(installed.values(), key=lambda x: x.name.lower()):
            f.write(f"{dist.name}=={dist.version}\n")
    print(colored(f"📝 requirements.txt exported to {path}", "cyan"))

def check_outdated():
    outdated = []
    for dist in pip_api.installed_distributions(local=True).values():
        latest = dist.latest_version
        if latest and latest != dist.version:
            print(colored(f"⬆️ {dist.name}: {dist.version} → {latest}", "yellow"))
            outdated.append(dist.name)
    return outdated

def export_json_deps(directory):
    tree = pip_api.installed_distributions(local=True)
    deps = {dist.name: dist.dependencies for dist in tree.values()}
    path = os.path.join(directory, "deps_tree.json")
    with open(path, "w") as f:
        json.dump(deps, f, indent=2)
    print(colored(f"📝 deps_tree.json exported to {path}", "cyan"))

def generate_dockerfile(directory):
    dockerfile_path = os.path.join(directory, "Dockerfile")
    content = f"""# Generated Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY . /app

RUN python -m pip install --upgrade pip \\
    && pip install -r requirements.txt

CMD ["python"]
"""
    with open(dockerfile_path, "w") as f:
        f.write(content)
    print(colored(f"🛠️ Dockerfile généré dans {dockerfile_path}", "cyan"))

def run(directory, auto=False):
    update_pip()
    create_venv()

    py_files = scan_python_files(directory)
    all_imports = set()
    for f in py_files:
        all_imports |= extract_imports(f)

    needed_pkgs = set()
    for mod in all_imports:
        if is_builtin(mod):
            continue
        pip_pkg = map_module_to_pip(mod)
        installed = pip_api.installed_distributions(local=True)
        if pip_pkg not in installed:
            needed_pkgs.add(pip_pkg)

    if auto:
        if needed_pkgs:
            install_parallel(needed_pkgs)
        outdated = check_outdated()
        if outdated:
            install_parallel(outdated, upgrade=True)
        audit_vulnerabilities()
        generate_requirements(directory)
        export_json_deps(directory)
        generate_dockerfile(directory)
        print(colored("🚀 AUTO mode completed.", "green"))
        return

    while True:
        print(colored("\n🚀 DepScanner Menu 🚀", "magenta"))
        print(colored("1. Installer les paquets manquants", "cyan"))
        print(colored("2. Mettre à jour les paquets obsolètes", "cyan"))
        print(colored("3. Scanner vulnérabilités", "cyan"))
        print(colored("4. Exporter requirements.txt", "cyan"))
        print(colored("5. Exporter arbre de dépendances JSON", "cyan"))
        print(colored("6. Générer Dockerfile", "cyan"))
        print(colored("0. Quitter", "red"))

        choice = input(colored("Choisissez une option : ", "yellow"))
        if choice == "1":
            install_parallel(needed_pkgs)
        elif choice == "2":
            outdated = check_outdated()
            if outdated:
                install_parallel(outdated, upgrade=True)
        elif choice == "3":
            audit_vulnerabilities()
        elif choice == "4":
            generate_requirements(directory)
        elif choice == "5":
            export_json_deps(directory)
        elif choice == "6":
            generate_dockerfile(directory)
        elif choice == "0":
            print(colored("👋 Bye!", "red"))
            break
        else:
            print(colored("Option invalide.", "red"))

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="DepScanner Auto V7")
    parser.add_argument(
        "directory", nargs='?', default=os.getcwd(),
        help="Chemin du projet (par défaut : dossier courant)"
    )
    parser.add_argument(
        "--auto", action="store_true",
        help="Exécute toutes les actions automatiquement (install, update, audit, export, Dockerfile)"
    )

    args = parser.parse_args()
    run(args.directory, auto=args.auto)

"@
    
    $pythonCode | Out-File -Encoding UTF8 $pyScriptPath -Force
    Write-Output "✅ Script Python écrit dans $pyScriptPath"
}

# Vérifier si pip doit être mis à jour
Write-Output "➡️ Mise à jour de pip..."
try {
    python -m pip install --upgrade pip
    Write-Output "✅ pip mis à jour."
} catch {
    Write-Output "❌ Erreur lors de la mise à jour de pip."
}

# Exécuter le script Python avec les arguments
Write-Output "➡️ Lancement de pyDeps avec arguments : $Args"
& python $pyScriptPath @Args
