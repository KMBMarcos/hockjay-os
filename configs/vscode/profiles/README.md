# Perfiles de VSCode

Esta carpeta contiene los perfiles de usuario de VSCode versionados en el repositorio. Cada subcarpeta usa el **ID interno** (`location`) que VSCode asigna al perfil; el **nombre real** se guarda fuera del repo, en `~/.config/Code/User/globalStorage/storage.json` (clave `userDataProfiles`).

## Resumen

| Perfil | ID (carpeta) | Tema de color | Iconos | Tipografía | Foco | Extensiones |
|---|---|---|---|---|---|---|
| [Pydev](345deeca/README.md) | `345deeca` | Aura Soft Dark | Helium | JetBrains Mono | Python + Jupyter | 12 |
| [Web](-768b300b/README.md) | `-768b300b` | Tokyo Night | *(predeterminado)* | *(global)* | Astro / TS / Prettier | 5 |
| [DotnetDev](7308086a/README.md) | `7308086a` | Dracula | *(predeterminado)* | *(global)* | .NET (solo tema por ahora) | 1 |

## Mapeo ID → nombre

```json
[
  { "location": "345deeca",  "name": "Pydev" },
  { "location": "-768b300b", "name": "Web" },
  { "location": "7308086a",  "name": "DotnetDev" }
]
```

## Estructura de cada perfil

Cada carpeta de perfil contiene:

- `settings.json` — ajustes específicos del perfil.
- `extensions.json` — listado de extensiones instaladas.
- `globalStorage/` — almacenamiento por extensión.
- `snippets/` — snippets de código del perfil.
- `README.md` — documentación del perfil (apariencia, ajustes y extensiones).

## Notas

- **Web** y **DotnetDev** no definen tema de iconos ni tipografía propios, por lo que heredan los valores globales de VSCode.
- **DotnetDev**, pese a su nombre, aún no tiene extensiones de C#/.NET instaladas (solo el tema Dracula).
