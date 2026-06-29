#!/usr/bin/env bash
# packages.sh - Modulo CORE de HockJayOS.
# Instala los paquetes base del sistema y despliega los dotfiles de Core (zsh, git).
# Es la base sobre la que construyen dev-tools.sh y themes.sh.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# install_eza - eza no esta en el apt de Ubuntu 22.04 (base de Mint 21); se anade su repo oficial.
install_eza() {
  if is_installed eza; then ok "eza ya instalado."; return 0; fi
  info "Instalando eza (repo oficial deb.gierens.de)..."
  sudo mkdir -p /etc/apt/keyrings
  if ! curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg; then
    warn "No se pudo obtener la clave de eza; omitiendo (el alias 'll' quedara sin eza)."
    return 0
  fi
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update
  sudo apt-get install -y eza || warn "No se pudo instalar eza; continuando."
}

# install_zsh_ecosystem - oh-my-zsh + powerlevel10k + plugins que requiere configs/zsh/.zshrc.
# Debe correr ANTES de enlazar el .zshrc para que el instalador de oh-my-zsh no lo sobreescriba.
install_zsh_ecosystem() {
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Instalando Oh My Zsh (desatendido)..."
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended
  else
    ok "Oh My Zsh ya instalado."
  fi

  # Tema powerlevel10k.
  if [[ ! -d "$zsh_custom/themes/powerlevel10k" ]]; then
    info "Instalando tema powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "$zsh_custom/themes/powerlevel10k"
  else
    ok "powerlevel10k ya instalado."
  fi

  # Plugins externos (git, sudo, fzf, docker, python son built-in de OMZ).
  local plugin
  for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ ! -d "$zsh_custom/plugins/$plugin" ]]; then
      info "Instalando plugin $plugin..."
      git clone --depth=1 "https://github.com/zsh-users/$plugin.git" \
        "$zsh_custom/plugins/$plugin"
    else
      ok "Plugin $plugin ya instalado."
    fi
  done

  install_eza
  ok "Ecosistema Zsh listo."
}

install_core() {
  require_apt

  info "Actualizando indice de paquetes (apt-get update)..."
  sudo apt-get update

  apt_install_list "$REPO_DIR/packages/apt.txt"

  # Ecosistema Zsh (oh-my-zsh, p10k, plugins, eza) ANTES de enlazar el .zshrc.
  install_zsh_ecosystem

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
