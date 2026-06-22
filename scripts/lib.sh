#!/usr/bin/env bash
# lib.sh - Helpers compartidos por los scripts de HockJayOS.
# Se obtiene con `source` desde los demas scripts; no esta pensado para ejecutarse solo.

# Raiz del repositorio (este archivo vive en scripts/).
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_DIR

# --- Logging con color ---
_c_reset=$'\033[0m'
_c_blue=$'\033[34m'
_c_green=$'\033[32m'
_c_yellow=$'\033[33m'
_c_red=$'\033[31m'

info() { printf '%s==>%s %s\n' "$_c_blue" "$_c_reset" "$*"; }
ok()   { printf '%s ok %s %s\n' "$_c_green" "$_c_reset" "$*"; }
warn() { printf '%s !! %s %s\n' "$_c_yellow" "$_c_reset" "$*" >&2; }
err()  { printf '%s xx %s %s\n' "$_c_red" "$_c_reset" "$*" >&2; }

# is_installed <comando> -> exito si el comando esta en el PATH.
is_installed() {
  command -v "$1" >/dev/null 2>&1
}

# confirm <pregunta> -> exito si el usuario responde "s" (por defecto: no).
confirm() {
  local reply
  read -r -p "$1 [s/N] " reply
  [[ "$reply" =~ ^[sSyY]$ ]]
}

# backup_and_link <origen-en-repo> <destino-en-sistema>
# Despliega un config por symlink. Si el destino ya es el symlink correcto, no hace nada
# (idempotente). Si existe un archivo/dir real, lo respalda en backup/ antes de enlazar.
backup_and_link() {
  local src="$1" dest="$2"
  if [[ ! -e "$src" ]]; then
    warn "No existe el origen: $src (omitido)"
    return 0
  fi

  # Ya enlazado correctamente -> nada que hacer.
  if [[ -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
    ok "Ya enlazado: $dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  # Respaldar cualquier archivo/dir real (no symlink nuestro) antes de sobrescribir.
  if [[ -e "$dest" || -L "$dest" ]]; then
    local backup_dir="$REPO_DIR/backup/backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    info "Respaldando $dest -> $backup_dir/"
    mv "$dest" "$backup_dir/"
  fi

  ln -sfn "$src" "$dest"
  ok "Enlazado: $dest -> $src"
}

# apt_install_list <archivo-manifiesto>
# Instala con apt los paquetes listados (uno por linea; ignora comentarios '#' y vacios).
apt_install_list() {
  local manifest="$1"
  if [[ ! -f "$manifest" ]]; then
    err "Manifiesto no encontrado: $manifest"
    return 1
  fi
  local pkgs=()
  while IFS= read -r line; do
    line="${line%%#*}"             # quitar comentario en linea
    line="${line//[[:space:]]/}"   # quitar espacios
    [[ -n "$line" ]] && pkgs+=("$line")
  done < "$manifest"

  if [[ ${#pkgs[@]} -eq 0 ]]; then
    warn "Sin paquetes en $manifest"
    return 0
  fi
  info "Instalando ${#pkgs[@]} paquetes desde $(basename "$manifest")..."
  sudo apt-get install -y "${pkgs[@]}"
}

# require_apt -> aborta si el sistema no usa apt (HockJayOS asume Linux Mint / Ubuntu).
require_apt() {
  if ! is_installed apt-get; then
    err "Este script requiere un sistema basado en apt (Linux Mint / Ubuntu)."
    exit 1
  fi
}
