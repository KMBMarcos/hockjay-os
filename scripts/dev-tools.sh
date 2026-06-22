#!/usr/bin/env bash
# dev-tools.sh - Modulo DEVELOPER de HockJayOS (Core + herramientas de desarrollo).
# Instala Docker, .NET SDK, DBeaver, Neovim y VS Code, y despliega sus configuraciones.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$(dirname "${BASH_SOURCE[0]}")/packages.sh"   # provee install_core()

install_docker() {
  if is_installed docker; then ok "Docker ya instalado."; return 0; fi
  info "Instalando Docker (script oficial get.docker.com)..."
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  rm -f /tmp/get-docker.sh
  sudo usermod -aG docker "$USER" && info "Agregado $USER al grupo docker (reinicia sesion para aplicarlo)."
  ok "Docker instalado."
}

install_dotnet() {
  if is_installed dotnet; then ok ".NET SDK ya instalado."; return 0; fi
  info "Instalando .NET SDK (repositorio de Microsoft)..."
  # Repo de paquetes de Microsoft para Ubuntu/Mint.
  local deb=/tmp/packages-microsoft-prod.deb
  source /etc/os-release
  curl -fsSL "https://packages.microsoft.com/config/ubuntu/${UBUNTU_CODENAME:-22.04}/packages-microsoft-prod.deb" -o "$deb" || {
    warn "No se pudo obtener el repo de Microsoft para esta version; omitiendo .NET."; return 0; }
  sudo dpkg -i "$deb"; rm -f "$deb"
  sudo apt-get update
  sudo apt-get install -y dotnet-sdk-8.0
  ok ".NET SDK instalado."
}

install_dbeaver() {
  if ! is_installed flatpak; then
    info "Instalando flatpak y conectando Flathub..."
    sudo apt-get install -y flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  fi
  info "Instalando apps Flatpak desde packages/flatpak.txt..."
  while IFS= read -r line; do
    line="${line%%#*}"; line="${line//[[:space:]]/}"
    [[ -z "$line" ]] && continue
    flatpak install -y flathub "$line"
  done < "$REPO_DIR/packages/flatpak.txt"
  ok "Apps Flatpak instaladas."
}

install_neovim() {
  if ! is_installed nvim; then
    info "Instalando Neovim..."
    sudo apt-get install -y neovim
  else
    ok "Neovim ya instalado."
  fi
  backup_and_link "$REPO_DIR/configs/nvim" "$HOME/.config/nvim"
}

install_vscode() {
  if ! is_installed code; then
    info "Instalando VS Code (repositorio de Microsoft)..."
    sudo apt-get install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
      | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
    rm -f /tmp/packages.microsoft.gpg
    sudo apt-get update
    sudo apt-get install -y code
  else
    ok "VS Code ya instalado."
  fi

  # Configuracion y extensiones.
  backup_and_link "$REPO_DIR/configs/vscode/settings.json" "$HOME/.config/Code/User/settings.json"

  local ext_file="$REPO_DIR/configs/vscode/extensions.txt"
  if [[ -f "$ext_file" ]]; then
    info "Instalando extensiones de VS Code..."
    while IFS= read -r ext; do
      ext="${ext%%#*}"; ext="${ext//[[:space:]]/}"
      [[ -z "$ext" ]] && continue
      code --install-extension "$ext" --force
    done < "$ext_file"
    ok "Extensiones de VS Code instaladas."
  else
    warn "No se encontro $ext_file; omitiendo extensiones."
  fi
}

install_developer() {
  install_core          # cada tier construye sobre Core
  info "Instalando herramientas de desarrollo..."
  install_docker
  install_dotnet
  install_dbeaver
  install_neovim
  install_vscode
  ok "Modulo Developer completado."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_developer
fi
