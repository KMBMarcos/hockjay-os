#!/usr/bin/env bash
# packages.sh - Modulo CORE de HockJayOS.
# Instala los paquetes base del sistema y despliega los dotfiles de Core (zsh, git).
# Es la base sobre la que construyen dev-tools.sh y themes.sh.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

install_core() {
  require_apt

  info "Actualizando indice de paquetes (apt-get update)..."
  sudo apt-get update

  apt_install_list "$REPO_DIR/packages/apt.txt"

  info "Desplegando dotfiles de Core..."
  backup_and_link "$REPO_DIR/configs/zsh/.zshrc"   "$HOME/.zshrc"
  backup_and_link "$REPO_DIR/configs/git/.gitconfig" "$HOME/.gitconfig"

  # Fijar Zsh como shell por defecto (decision del proyecto: shell = Zsh).
  if is_installed zsh && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
    if confirm "Establecer Zsh como shell por defecto (chsh)?"; then
      chsh -s "$(command -v zsh)" && ok "Shell por defecto cambiado a Zsh (efectivo al reiniciar sesion)."
    fi
  fi

  ok "Modulo Core completado."
}

# Permite ejecutarlo directo o ser obtenido con source desde otros modulos.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_core
fi
