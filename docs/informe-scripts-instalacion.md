# Informe — Implementación de los scripts de instalación

**Fecha de creación:** 2026-06-22 13:02:31 AST

Este informe documenta la implementación del motor de instalación de HockJayOS (los scripts de
`scripts/`), que hasta ahora eran stubs de 0–1 líneas. La implementación sigue la "Installation
Philosophy" de [`docs/spec.md`](spec.md): instalación modular por niveles donde cada tier construye
sobre Core.

---

## Scripts (antes stubs, ahora funcionales)

- **`scripts/lib.sh`** (nuevo) — helpers compartidos: `REPO_DIR`, logging con color, `backup_and_link`
  (symlink idempotente con respaldo previo), `apt_install_list`, `is_installed`, `confirm`, `require_apt`.
- **`scripts/packages.sh`** — Core: `apt update`, instala desde `apt.txt`, despliega `.zshrc`/`.gitconfig`,
  ofrece `chsh` a Zsh.
- **`scripts/dev-tools.sh`** — Core + Docker (script oficial), .NET SDK (repo MS), DBeaver (flatpak),
  Neovim, VS Code + extensiones desde `extensions.txt`. Con guards `is_installed` para no reinstalar.
- **`scripts/themes.sh`** — Core + Orchis Dark, Papirus, JetBrains Mono, aplicación vía `gsettings`,
  configs de kitty/fastfetch y wallpaper desde `wallpapers/`.
- **`scripts/backup.sh`** — respalda dotfiles existentes a `backup/backup-<timestamp>/`.
- **`scripts/install.sh`** — menú interactivo `[1] Core  [2] Developer  [3] Visual  [4] Full  [5] Salir`.

Cada tier construye sobre Core (sourcing de `packages.sh`), como pide el spec.

---

## Manifiestos (antes vacíos)

- **`packages/apt.txt`** — paquetes Core.
- **`packages/flatpak.txt`** — DBeaver.

---

## Ajustes según las decisiones tomadas

- **Spec → estructura real**: se reemplazó `assets/` por la estructura plana actual (`wallpapers/` en raíz,
  logo en `configs/fastfetch/logo/`).
- **Zsh**: el diagrama de `update-guide.md` ahora dice Zsh (y se limpió basura de trailing whitespace). En
  `spec.md` se añadió "Zsh Terminal Default" al Core.
- **Rename**: `extentions.txt` → `extensions.txt` (con `git mv`).

---

## Verificación

- `bash -n` limpio en los 6 scripts.
- Pruebas en aislado: parseo de manifiestos ✓, idempotencia de `backup_and_link` ✓, manejo de origen
  inexistente ✓, `REPO_DIR` correcto al ejecutar con bash ✓.
- shellcheck no está instalado (omitido).

---

## Notas

- **No se probó la instalación real** (instala paquetes del sistema y cambia el shell). Se recomienda correr
  `install.sh` primero en una VM/contenedor de Linux Mint antes de la máquina real.
- **Fuera de alcance** (brechas separadas pendientes):
  - Contenido real de `configs/nvim/` y `configs/zsh/.zshrc` (siguen como stubs; los scripts los despliegan igual).
  - El tier Productivity (Obsidian).
  - `CHANGELOG.md`, `LICENSE`, `releases/`.
