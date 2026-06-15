#!/usr/bin/env bash
# Gate déterministe du harness : lint + test + build.
# La tâche n'est "terminée" que si ce script sort en code 0.
# Usage : bash scripts/verify.sh [projet]
#   - Sans argument : vérifie tous les sous-projets détectés.
#   - Avec argument (backend|frontend) : vérifie uniquement ce projet.
#
# ⚙️ REMPLIR : adapter PROJECTS et les commandes de test à la stack détectée.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAIL=0

# Couleurs (désactivées si pas de TTY)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  CYAN=''
  NC=''
fi

log() { echo -e "${CYAN}$*${NC}"; }
ok()  { echo -e "${GREEN}✓ $*${NC}"; }
ko()  { echo -e "${RED}✗ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠ $*${NC}"; }

# Détecte le package manager utilisé par le sous-projet (pnpm > yarn > npm).
detect_pm() {
  local dir="$1"
  if [ -f "$dir/pnpm-lock.yaml" ] || [ -f "$dir/.pnpm-workspace-state-v1.json" ]; then
    echo "pnpm"
  elif [ -f "$dir/yarn.lock" ]; then
    echo "yarn"
  else
    echo "npm"
  fi
}

run() {
  local label="$1"; shift
  log "▶ $label : $*"
  if "$@"; then
    ok "$label OK"
  else
    ko "$label ÉCHEC"
    FAIL=1
  fi
}

# ⚙️ REMPLIR : liste les sous-projets à vérifier.
PROJECTS=([NOM_DU_PROJET_1] [NOM_DU_PROJET_2])
if [ $# -ge 1 ]; then
  PROJECTS=("$1")
fi

for dir in "${PROJECTS[@]}"; do
  pkg="$ROOT/$dir/package.json"
  [ -f "$pkg" ] || continue

  echo ""
  log "=========================================="
  log " Projet : $dir"
  log "=========================================="

  pushd "$ROOT/$dir" >/dev/null

  PM=$(detect_pm "$ROOT/$dir")
  log "Package manager détecté : $PM"

  # Installe les dépendances si le dossier node_modules est absent (CI friendly).
  if [ ! -d "node_modules" ]; then
    warn "node_modules absent — installation automatique ($PM install)"
    run "install ($dir)" "$PM" install
  fi

  # Lint
  if $PM run | grep -qE '^\s*lint'; then
    run "lint ($dir)" "$PM" run lint
  else
    warn "pas de script 'lint' dans $dir, ignoré"
  fi

  # Tests : essaie d'abord une version headless / single-run quand elle existe.
  if $PM run | grep -qE '^\s*test:ci'; then
    run "test:ci ($dir)" "$PM" run test:ci --silent
  elif $PM run | grep -qE '^\s*test'; then
    # ⚙️ REMPLIR : adapter la commande de test au framework.
    # Exemple Angular : ng test --watch=false
    # Exemple Jest/Vitest : $PM test --silent
    if grep -q '"test": "ng test"' package.json 2>/dev/null; then
      run "test ($dir)" "$PM" test --watch=false
    else
      run "test ($dir)" "$PM" test --silent
    fi
  else
    warn "pas de script 'test' dans $dir, ignoré"
  fi

  # Build
  if $PM run | grep -qE '^\s*build'; then
    run "build ($dir)" "$PM" run build
  else
    warn "pas de script 'build' dans $dir, ignoré"
  fi

  popd >/dev/null
done

echo ""
if [ "$FAIL" -ne 0 ]; then
  ko "VERIFY a échoué — la tâche N'EST PAS terminée."
  exit 1
fi
ok "VERIFY OK — tous les checks passent."
