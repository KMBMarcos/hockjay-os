# HockJayOS Specification

## Project Overview

**Project Name:** HockJayOS
**Version:** 1.0.0 Panthera Edition
**Status:** Initial Release

HockJayOS is a reproducible Linux development environment designed for software engineers, creators, and technical professionals who require a stable, productive, and personalized workstation.

The project focuses on automation, consistency, maintainability, and developer experience by providing scripts, configurations, documentation, and visual identity components that allow the environment to be recreated on a fresh Linux Mint Cinnamon installation.

---

# Vision

Create a professional workstation environment where system configuration becomes reproducible infrastructure instead of manual setup.

The goal is not to create a new Linux distribution, but to provide a curated development ecosystem built on top of Linux Mint.

---

# Objectives

## Primary Objectives

* Provide a reproducible Linux workstation setup.
* Automate installation of essential development tools.
* Preserve personal configurations.
* Reduce environment migration time.
* Maintain a professional developer workflow.

## Secondary Objectives

* Establish a personal technical identity.
* Document infrastructure decisions.
* Serve as a portfolio project demonstrating:

  * Linux administration
  * Automation
  * Developer tooling
  * Configuration management
  * Documentation practices

---

# Target Environment

## Base Operating System

Linux Mint Cinnamon

Reason:

* Stability
* Ubuntu LTS ecosystem
* Hardware compatibility
* Developer-friendly environment

---

# Design Principles

## Reproducibility

A fresh installation should be able to recover the environment using repository scripts.

## Modularity

Users should be able to install only the components they need.

Example:

* Core environment
* Developer tools
* Visual customization
* Productivity tools

## Maintainability

Configurations should be version-controlled and documented.

## Minimal Complexity

Avoid unnecessary customization that increases maintenance cost.

---

# Architecture

```
HockJayOS

|
├── Core Environment
|
├── Developer Environment
|
├── Visual Identity
|
├── Productivity Tools
|
└── Documentation
```

---

# Components

## Core Environment

Includes:

* Git
* Curl
* Wget
* Build tools
* Python environment
* Zsh Terminal Default
* Terminal utilities

## Developer Environment

Includes:

* Docker
* Python tooling
* .NET SDK
* VS Code
* Neovim
* Database tools

## Visual Identity

Includes:

* Orchis Dark Theme
* Papirus Dark Icons
* JetBrains Mono
* Kitty configuration
* Fastfetch branding
* HockJayOS wallpaper

## Productivity Environment

Includes:

* Obsidian
* Firefox configuration
* Bitwarden setup documentation

---

# Repository Structure

```
hockjay-os/

├── configs/        # dotfiles (incluye fastfetch/logo/ con el branding)
├── docs/
├── packages/       # manifiestos apt.txt y flatpak.txt
├── scripts/
├── wallpapers/     # imagenes de fondo (wallpaper Panthera)
├── backup/         # respaldos generados por scripts/backup.sh
└── releases/
```

> Nota: la identidad visual (logo y wallpapers) no vive en una carpeta `assets/` separada:
> el logo de Fastfetch esta en `configs/fastfetch/logo/` y los fondos en `wallpapers/`.

---

# Installation Philosophy

HockJayOS will follow a hybrid installation approach.

Users can:

1. Install everything.
2. Install specific modules.
3. Manually apply configurations.

Example:

```
./install.sh

Select:

[1] Core
[2] Developer
[3] Visual
[4] Productivity
[5] Full Installation
```

---

# Versioning Strategy

Semantic versioning:

```
MAJOR.MINOR.PATCH
```

Examples:

```
1.0.0
Initial stable environment

1.1.0
New features

1.1.1
Bug fixes
```

---

# Release Strategy

## v1.0.0 Panthera Edition

Initial release.

Includes:

* Linux Mint base configuration
* Developer tooling
* Visual identity
* Fastfetch branding
* VS Code backup system
* Documentation
* Installation scripts

---

# Future Roadmap

## v1.1.0

Possible additions:

* Improved terminal experience
* Shell customization
* More automation scripts
* Better backup workflow

## v1.2.0

Possible additions:

* Enhanced Neovim configuration
* Creator tools
* Content production utilities

## Future

Support for additional Linux distributions may be considered.

---

# Non Goals

HockJayOS is not intended to:

* Replace Linux distributions.
* Become a package manager.
* Maintain custom repositories.
* Support every Linux environment.

---

# Success Criteria

The project is considered successful when:

* A clean Linux Mint installation can reproduce the environment.
* Configuration recovery is automated.
* The workflow remains stable after updates.
* Documentation allows another developer to understand the system.

---

# Maintainer

HockJayOS is maintained as a personal engineering environment and portfolio project.
