#!/usr/bin/env bash
# themes.sh - Modulo VISUAL de HockJayOS (Core + identidad visual).
# Instala tema, iconos y fuente, los aplica en Cinnamon via gsettings, despliega los
# configs de terminal (kitty, fastfetch) y fija el wallpaper.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$(dirname "${BASH_SOURCE[0]}")/packages.sh"   # provee install_core()

install_icons_and_font() {
  info "Instalando iconos Papirus y fuente JetBrains Mono..."
  sudo apt-get install -y papirus-icon-theme fonts-jetbrains-mono
  ok "Iconos y fuente instalados."
}

install_orchis_theme() {
  if [[ -d "$HOME/.themes/Orchis-Dark" || -d /usr/share/themes/Orchis-Dark ]]; then
    ok "Tema Orchis ya instalado."; return 0
  fi
  info "Instalando tema Orchis Dark (desde el repo oficial)..."
  local tmp; tmp="$(mktemp -d)"
  if git clone --depth=1 https://github.com/vinceliuice/Orchis-theme.git "$tmp"; then
    "$tmp/install.sh" -c dark
    rm -rf "$tmp"
    ok "Tema Orchis Dark instalado."
  else
    warn "No se pudo clonar Orchis-theme; omitiendo tema."
    rm -rf "$tmp"
  fi
}

apply_appearance() {
  if ! is_installed gsettings; then
    warn "gsettings no disponible; no se aplica la apariencia (entorno no Cinnamon?)."
    return 0
  fi
  info "Aplicando apariencia en Cinnamon..."
  gsettings set org.cinnamon.desktop.interface gtk-theme   "Orchis-Dark"   || true
  gsettings set org.cinnamon.desktop.wm.preferences theme  "Orchis-Dark"   || true
  gsettings set org.cinnamon.desktop.interface icon-theme  "Papirus-Dark"  || true
  gsettings set org.cinnamon.desktop.interface font-name   "JetBrains Mono 10" || true
  ok "Apariencia aplicada."
}

deploy_terminal_configs() {
  info "Desplegando configs de terminal (kitty, fastfetch)..."
  backup_and_link "$REPO_DIR/configs/kitty"     "$HOME/.config/kitty"
  backup_and_link "$REPO_DIR/configs/fastfetch" "$HOME/.config/fastfetch"
}

apply_wallpaper() {
  # El wallpaper vive en wallpapers/ (raiz del repo). Se toma el primer png/jpg disponible.
  local wp
  wp="$(find "$REPO_DIR/wallpapers" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' \) | head -n1)"
  if [[ -z "$wp" ]]; then
    warn "No hay wallpaper en wallpapers/; omitiendo."
    return 0
  fi
  if is_installed gsettings; then
    gsettings set org.cinnamon.desktop.background picture-uri "file://$wp" || true
    ok "Wallpaper aplicado: $(basename "$wp")"
  else
    warn "gsettings no disponible; no se aplica el wallpaper."
  fi
}

install_visual() {
  install_core          # cada tier construye sobre Core
  info "Instalando identidad visual..."
  install_icons_and_font
  install_orchis_theme
  apply_appearance
  deploy_terminal_configs
  apply_wallpaper
  ok "Modulo Visual completado."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_visual
fi
