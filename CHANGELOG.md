# Changelog

Todos los cambios notables de **HockJayOS** se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/)
y el proyecto sigue el versionado [SemVer](https://semver.org/lang/es/) (`MAJOR.MINOR.PATCH`).

## [Unreleased]

## [1.1.0] - 2026-06-29 — Panthera Edition

### Added
- Licencia **MIT** (`LICENSE`) con atribución obligatoria al autor.
- Sección **Licencia** en el `README.md`.
- Este archivo `CHANGELOG.md`.
- Directorio `configs/bash/` (placeholder) para los dotfiles de Bash.
- Directorio `releases/` (placeholder) para las notas de versión por edición.
- Instalación del ecosistema Zsh en `packages.sh` (oh-my-zsh, powerlevel10k,
  plugins y eza) con la configuración del autor.
- Configuración de `zsh/` (`.zshrc`).
- Configuración de `kitty/`.
- Instalación de Hack Nerd Font en `themes.sh` para la terminal.

### Changed
- Reorganización del `README.md`: marcado como *En desarrollo*, separadores
  entre secciones y reestructuración del apartado de Componentes.
- Configuración de `fastfetch/` actualizada a su estado actual.

## [1.0.0] - 2026-06-22 — Panthera Edition

### Added
- Estructura inicial del proyecto HockJayOS (arquitectura de instalación modular).
- Esqueleto de `scripts/` (install, packages, themes, dev-tools, vscode, docker,
  dotfiles, backup) como stubs.
- Esqueleto de `configs/` (nvim, kitty, fastfetch, vscode, zsh, git).
- Documentación de diseño en `docs/` (`spec.md`, `software-stack.md`, `update-guide.md`).
- `README.md` inicial en español.
