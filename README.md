# Hockjay OS - v1.0.0
> *Este es un proyecto muy especial para mi y un proyecto que le recomiendo a todo entusiaste tech que le gusta trabajar en Linux como ami. Crear una version personalizada de una distro de Linux ajustada a tu persona. Esto es un reto personal y me lo quiero tomar enserio. Voy a abarcar desde las configuraciones del sistema que uso, paquetes, apps, colores, fondos de pantallas, lock screen, terminal, entre otras cosas mas.*
>
> *Voy a dejar todo claro y explicado para que si quieres tomar alguna parte o configuracion de HockjayOS, lo puedas llevar a tu distro.*
>
>*"Linux es de todos"*
## Objetivo
> Un entorno Linux Mint Cinnamon enfocado en desarrollo y productividad (por ahora), con identidad visual propia y configuración reproducible.

## Componentes

### Developer Edition

#### Backend
- Python
- Django
- .NET SDK
- Docker
- DBeaver

#### Herramientas
- ripgrep
- fd
- fzf
- tree
- jq

### Visual Edition
- Tema
- Orchis Dark
- Papirus Dark
- JetBrains Mono
- Wallpaper

### Terminal Edition
- Kitty
- Fastfetch

### Visual Code Edition

configs/vscode/

 - settings.json
 - keybindings.json
 - extensions.txt
 - snippets/

### NeoVim
 - 
 -
 -
 -



## Estructura
```
hockjay-os/
│
├── README.md
├── CHANGELOG.md
├── LICENSE
├── install.sh
│
├── docs/
│   │
│   ├── installation.md
│   ├── recovery.md
│   ├── update-guide.md
│   ├── software-stack.md
│   └── philosophy.md
│
├── assets/
│   │
│   ├── wallpapers/
│   │   └── hockjayos-panthera.png
│   │
│   ├── logos/
│   │   └── hockjay-fastfetch.ansi
│   │
│   └── screenshots/
│
├── configs/
│   │
│   ├── bash/
│   │   └── .bashrc
│   │
│   ├── kitty/
│   │   └── kitty.conf
│   │
│   ├── fastfetch/
│   │   └── config.jsonc
│   │
│   ├── btop/
│   │
│   ├── nvim/
│   │   └── README.md
│   │
│   ├── vscode/
│   │   │
│   │   ├── profile/
│   │   ├── settings.json
│   │   ├── keybindings.json
│   │   ├── snippets/
│   │   └── extensions.txt
│   │
│   └── obsidian/
│       └── README.md
│
├── scripts/
│   │
│   ├── install.sh
│   ├── packages.sh
│   ├── themes.sh
│   ├── dev-tools.sh
│   ├── vscode.sh
│   ├── docker.sh
│   ├── dotfiles.sh
│   └── backup.sh
│
├── packages/
│   │
│   ├── apt.txt
│   └── flatpak.txt
│
└── releases/
    │
    └── v1.0.0.md
```