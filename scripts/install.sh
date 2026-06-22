#!/usr/bin/env bash
# install.sh - Punto de entrada interactivo de HockJayOS.
# Instalacion modular: cada tier construye sobre Core (ver docs/spec.md).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

banner() {
  cat <<'EOF'

  HockJayOS - Instalador
  ----------------------
  [1] Core         (paquetes base + dotfiles de shell/git)
  [2] Developer    (Core + Docker, .NET, DBeaver, Neovim, VS Code)
  [3] Visual       (Core + tema, iconos, fuente, terminal, wallpaper)
  [4] Full         (Developer + Visual)
  [5] Salir

EOF
}

main() {
  require_apt
  while true; do
    banner
    read -r -p "Selecciona una opcion [1-5]: " opt
    case "$opt" in
      1) bash "$SCRIPT_DIR/packages.sh" ;;
      2) bash "$SCRIPT_DIR/dev-tools.sh" ;;
      3) bash "$SCRIPT_DIR/themes.sh" ;;
      4) bash "$SCRIPT_DIR/dev-tools.sh"; bash "$SCRIPT_DIR/themes.sh" ;;
      5) info "Saliendo."; exit 0 ;;
      *) warn "Opcion invalida: $opt" ;;
    esac
  done
}

main "$@"
