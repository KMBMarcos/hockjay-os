# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

HockJayOS is **not an application** — it is a reproducible Linux workstation setup (a curated dotfiles + automation project) layered on top of **Linux Mint Cinnamon**. The goal is that a fresh Mint install can recover the maintainer's full environment by running scripts from this repo. It is explicitly *not* a new distribution, package manager, or custom repository (see `docs/spec.md` → "Non Goals").

There is no build, test, or lint step. "Running" the project means executing the install/setup scripts on a target machine, and "correctness" means a clean Mint install reproduces the environment.

The README is written in Spanish; most docs/specs are in English. The maintainer (`KMBMarcos`) works in Spanish — match the language of the file you're editing.

## Current state — read before editing

The install engine is **implemented and functional** (no longer stubs): `scripts/lib.sh` (shared helpers), `scripts/install.sh` (interactive menu), `scripts/packages.sh` (Core), `scripts/dev-tools.sh` (Developer), `scripts/themes.sh` (Visual), and `scripts/backup.sh` all contain real logic. `packages/apt.txt` and `packages/flatpak.txt` are populated manifests. Implementation notes live in `docs/informe-scripts-instalacion.md`.

**Still incomplete / known gaps:**
- `configs/nvim/*.lua` (`init.lua`, `lua/{keymaps,options,plugins}.lua`) are empty — the scripts deploy them anyway, so they'd link empty files.
- `configs/git/` has no `.gitconfig`; `packages.sh` references it but `backup_and_link` skips a missing source gracefully (warns only).
- The **Productivity** tier (Obsidian, Firefox, Bitwarden) is not implemented; `install.sh` offers only Core/Developer/Visual/Full.
- The scripts have **never been run end-to-end on a real Mint install** — only syntax-checked (`bash -n`) and tested in isolation. Recommend a VM/container before a real machine.

The `docs/spec.md` file is the authoritative design document — align new work with the architecture, modularity, and installation philosophy described there.

## Intended architecture (the modular install model)

The design centers on **independently installable modules** so a user can install only what they need. `scripts/install.sh` is the interactive entry point. It currently offers:

```
[1] Core      → apt.txt base pkgs + Zsh ecosystem (oh-my-zsh, powerlevel10k,
                plugins, eza) + zsh/git dotfiles                          (packages.sh)
[2] Developer → Core + Docker, .NET SDK, DBeaver (flatpak), Neovim, VS Code (dev-tools.sh)
[3] Visual    → Core + Orchis Dark, Papirus, Hack Nerd Font, gsettings,
                Kitty, Fastfetch, wallpaper                               (themes.sh)
[4] Full      → Developer + Visual
[5] Salir
```

Each tier builds on Core: `dev-tools.sh` and `themes.sh` both `source packages.sh` and call `install_core()` first. Keep this layering. Shared helpers (logging, `backup_and_link`, `apt_install_list`, `is_installed`, `confirm`, `require_apt`, `REPO_DIR`) live in `scripts/lib.sh` — reuse them rather than reinventing.

**The standard coding/terminal font is Hack Nerd Font** (kitty `font_family`, gsettings `font-name`); `themes.sh` downloads it from `ryanoasis/nerd-fonts`. The Productivity tier from `docs/spec.md` is not wired into the menu yet.

## Repository layout

- `scripts/` — installation/automation scripts (the actuators): `lib.sh` (shared helpers, sourced by the rest), `install.sh`, `packages.sh`, `dev-tools.sh`, `themes.sh`, `backup.sh`
- `configs/` — version-controlled dotfiles, one directory per tool: `nvim/` (Lua config under `lua/`, still empty), `kitty/`, `fastfetch/` (config + `logo/hockjay.ansi`), `vscode/` (settings + `extensions.txt` + exported `profiles/`), `zsh/` (`.zshrc`), `bash/` and `git/` (empty)
- `docs/` — `spec.md` (design authority), `software-stack.md`, `update-guide.md`
- `packages/`, `wallpapers/`, `backup/` — asset/data directories

Config files use paths as they'll be installed to the target system (e.g. `fastfetch/config.jsonc` references `~/.config/fastfetch/logo/hockjay.ansi`). When editing a config, keep references consistent with where the install scripts will place files.

## Conventions

- **Versioning:** semantic `MAJOR.MINOR.PATCH`; releases are named editions (current: `v1.0.0 Panthera Edition`).
- **Update workflow** (`docs/update-guide.md`): add a `releases/vX.Y.Z.md`, run `./scripts/backup.sh` *before* modifying anything, update `CHANGELOG.md` (Added/Changed/Fixed), then commit.
- **VS Code:** `configs/vscode/profiles/` holds exported profiles (including binary `state.vscdb` SQLite files) — these are generated exports, not hand-edited.
- **Changes** Verify before processing a PR or commit, and record changes in CHANGELOG.md following the correct convention.