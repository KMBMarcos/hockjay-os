#!/usr/bin/env bash
# backup.sh - Respalda los dotfiles actuales del sistema antes de modificarlos.
# Exigido por docs/update-guide.md como paso previo a cualquier cambio.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Rutas del sistema a respaldar (las que existan).
TARGETS=(
  "$HOME/.zshrc"
  "$HOME/.gitconfig"
  "$HOME/.config/nvim"
  "$HOME/.config/kitty"
  "$HOME/.config/fastfetch"
  "$HOME/.config/Code/User/settings.json"
)

run_backup() {
  local dest="$REPO_DIR/backup/backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$dest"
  info "Respaldando dotfiles en $dest"

  local count=0
  for t in "${TARGETS[@]}"; do
    if [[ -e "$t" ]]; then
      # -L copia el contenido aunque sea symlink; preserva estructura relativa al HOME.
      cp -RL "$t" "$dest/" 2>/dev/null && { ok "Respaldado: $t"; count=$((count+1)); }
    fi
  done

  if [[ "$count" -eq 0 ]]; then
    warn "No habia dotfiles que respaldar."
    rmdir "$dest" 2>/dev/null || true
  else
    ok "Backup completado ($count elementos) en $dest"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_backup
fi
