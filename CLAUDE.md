# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

HockJayOS is **not an application** — it is a reproducible Linux workstation setup (a curated dotfiles + automation project) layered on top of **Linux Mint Cinnamon**. The goal is that a fresh Mint install can recover the maintainer's full environment by running scripts from this repo. It is explicitly *not* a new distribution, package manager, or custom repository (see `docs/spec.md` → "Non Goals").

There is no build, test, or lint step. "Running" the project means executing the install/setup scripts on a target machine, and "correctness" means a clean Mint install reproduces the environment.

The README is written in Spanish; most docs/specs are in English. The maintainer (`KMBMarcos`) works in Spanish — match the language of the file you're editing.

## Current state — read before editing

The project is in an early scaffolding phase. **Most files under `scripts/` and several config files contain only a one-line comment describing their intended purpose, not real implementation.** For example `scripts/install.sh`, `scripts/packages.sh`, `scripts/themes.sh`, `scripts/dev-tools.sh`, and `scripts/backup.sh` are placeholder stubs. Treat the comment as the spec for what that file should eventually do; don't assume working code exists.

The `docs/spec.md` file is the authoritative design document — when implementing a stub, align it with the architecture, modularity, and installation philosophy described there.

## Intended architecture (the modular install model)

The design centers on **independently installable modules** so a user can install only what they need. `scripts/install.sh` is meant to be the interactive entry point offering:

```
[1] Core        → git, curl, wget, build tools, Python env, terminal utils   (packages.sh)
[2] Developer   → Docker, Python tooling, .NET SDK, VS Code, Neovim, DB tools (dev-tools.sh)
[3] Visual      → Orchis Dark theme, Papirus Dark icons, JetBrains Mono, wallpaper, Kitty, Fastfetch (themes.sh)
[4] Productivity → Obsidian, Firefox, Bitwarden docs
[5] Full
```

Each tier builds on Core (`dev-tools.sh` = Core + dev tools; `themes.sh` = Core + themes). Keep this layering when implementing scripts.

## Repository layout

- `scripts/` — installation/automation scripts (the actuators; currently stubs)
- `configs/` — version-controlled dotfiles, organized one directory per tool: `nvim/` (Lua config under `lua/`), `kitty/`, `fastfetch/` (config + `logo/hockjay.ansi`), `vscode/` (settings + `extentions.txt` + exported `profiles/`), `bash/`, `zsh/`, `git/` (several still empty)
- `docs/` — `spec.md` (design authority), `software-stack.md`, `update-guide.md`
- `packages/`, `wallpapers/`, `backup/` — asset/data directories

Config files use paths as they'll be installed to the target system (e.g. `fastfetch/config.jsonc` references `~/.config/fastfetch/logo/hockjay.ansi`). When editing a config, keep references consistent with where the install scripts will place files.

## Conventions

- **Versioning:** semantic `MAJOR.MINOR.PATCH`; releases are named editions (current: `v1.0.0 Panthera Edition`).
- **Update workflow** (`docs/update-guide.md`): add a `releases/vX.Y.Z.md`, run `./scripts/backup.sh` *before* modifying anything, update `CHANGELOG.md` (Added/Changed/Fixed), then commit.
- **VS Code:** `configs/vscode/profiles/` holds exported profiles (including binary `state.vscdb` SQLite files) — these are generated exports, not hand-edited.
