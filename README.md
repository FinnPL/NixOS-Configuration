# NixOS Configuration
[![Test NixOS Configuration](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/test.yml/badge.svg)](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/test.yml)
[![Evaluate NixOS Configuration](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/build.yml/badge.svg)](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/build.yml)

My NixOS configuration using flakes with Hyprland, Quickshell, Home Manager, and modular structure.

## Overview

This repository contains a complete NixOS configuration featuring:
- **Hyprland** - Modern Wayland compositor
- **Quickshell** - Modern Qt6/QML-based desktop shell
- **Home Manager** - Declarative user environment management  
- **Stylix** - System-wide theming with automatic Quickshell integration
- **Modular structure** - Clean separation of concerns
- **Multiple hosts** - Shared modules, per-host hardware and parameters

## Hosts

| Host | Type | Notes |
|------|------|-------|
| `centaur` | Laptop | GRUB, single `eDP-1` display, touchpad, `ch`/`de` keyboard |
| `orthrus` | Desktop | systemd-boot, latest kernel (AMD RDNA 4), three monitors with 4 workspaces each, `de` keyboard, Steam/gaming |

## Quick Start

### Prerequisites
- NixOS installed with flakes enabled
- Git for cloning this repository
- Ensure `/usr/share/wallpaper/` exists and contains all wallpapers you want to use for theming

### Installation

1. Clone this repository:
```bash
git clone https://github.com/FinnPL/NixOS-Configuration /etc/nixos
cd /etc/nixos
```

2. Deploy the configuration (defaults to the current `hostname`):
```bash
chmod +x deploy.sh
./deploy.sh            # deploy configuration for $(hostname)
./deploy.sh orthrus    # deploy a specific host
```

3. To update flake inputs before deployment:
```bash
./deploy.sh -up [host]
```

## Architecture

### Flake Structure

The configuration is built using Nix flakes with the following inputs:
- **nixpkgs** - Latest unstable channel
- **home-manager** - User environment management
- **firefox-addons** - Firefox extensions via NUR
- **stylix** - System-wide theming framework
- **nixcord** - Declarative Discord (Vencord) configuration
- **hyprland** / **hyprland-plugins** - Wayland compositor and plugins
- **quickshell** - Qt6/QML desktop shell (added via overlay)
- **wallpapers** - Impure `path:/usr/share/wallpaper` input holding theme wallpapers

Every host is built with the same `mkHost` helper in `flake.nix`, which wires in Home Manager, Stylix, nixcord and the Quickshell overlay.

### Directory Structure

```
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked input versions
├── deploy.sh                    # Deployment script
├── hosts/                       # Host-specific configurations
│   ├── centaur/                 # Laptop
│   │   ├── configuration.nix    # System configuration
│   │   ├── hardware-configuration.nix  # Hardware settings
│   │   └── home.nix             # User configuration
│   └── orthrus/                 # Desktop
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── modules/                     # Modular configurations
│   ├── home-manager/           # User-level modules
│   ├── hyprland/              # Hyprland-specific modules
│   ├── nixos/                 # System-level modules
│   └── quickshell/            # Quickshell desktop shell
└── none-nix/                   # Non-Nix configuration files
```

## Module System

### Home Manager Modules

Located in `modules/home-manager/`:

- **basics.nix** - Essential packages and settings
- **cli-tools.nix** - Command-line utilities
- **discord.nix** - Discord configuration
- **firefox.nix** - Firefox with extensions
- **haskell.nix** - Haskell toolchain
- **jetbrains.nix** - JetBrains IDE suite
- **kitty.nix** - Terminal emulator configuration
- **latex.nix** - TeX Live, Zotero and LaTeX Workshop for VS Code
- **neovim.nix** - Neovim configuration
- **python.nix** - Python development environment
- **rust.nix** - Rust toolchain
- **security-tools.nix** - Security/pentesting tools
- **thunderbird.nix** - Email client
- **vscode.nix** - Visual Studio Code setup
- **zsh.nix** - Zsh shell configuration

### Hyprland Modules

Located in `modules/hyprland/`:

- **hyprland-config.nix** - Window manager settings, keybinds and animations
- **hyprpaper.nix** - Wallpaper management
- **cliphist.nix** - Clipboard history
- **waybar.nix**, **mako.nix** - Legacy, unused (replaced by Quickshell)

Hosts import these modules directly. `hyprland-config.nix` is a function, so each host passes its own hardware details:

```nix
(import ../../modules/hyprland/hyprland-config.nix {
  monitors = [{ output = "DP-1"; mode = "2560x1440@144"; position = "0x0"; scale = 1; }];
  workspaceRules = [];          # e.g. pin workspaces to monitors
  keyboardLayout = "de";
  keyboardVariant = "";
  enableTouchpad = false;
  workspacesPerMonitor = 4;     # null = global workspaces
})
```

### Quickshell Modules

Located in `modules/quickshell/`:

This is a complete Qt6/QML desktop shell based on [illogical-impulse](https://github.com/end-4/dots-hyprland), featuring:

- **shell-config.nix** - Main Quickshell configuration and Nix integration. Takes `workspacesShown` (default `10`) and an optional `workspaceNumberMap` to relabel workspaces, e.g. per-monitor numbering `1-4`
- **generate-colors.py** - Automatic Material Design color generation from Stylix theme
- **config/** - QML shell components including:
  - **Bar** - Status bar with system info, weather, workspaces
  - **Overview** - Window overview and app launcher
  - **Sidebar** - Notifications, calendar, quick toggles, brightness/volume sliders
  - **Lock screen** - Session lock with customizable clock widgets
  - **On-screen display** - Volume, brightness indicators
  - **Notification popups** - Desktop notifications
  - **Session screen** - Power/logout menu

#### Quickshell Features

- **Stylix Integration** - Colors automatically generated from your theme
- **Declarative Config** - All settings managed through Nix
- **Services** - Weather, battery, audio, Bluetooth, network status, and more
- **Search** - App launcher with math, web search, and file search capabilities

### NixOS Modules

Located in `modules/nixos/`:

- **auto.nix** - Automatic updates and cleanup
- **steam.nix** - Steam (Proton-GE, gamescope session), gamemode and LACT GPU control
- **stylix-config.nix** - System-wide theming

## Maintenance

### Automatic Maintenance

The configuration includes automatic maintenance via `modules/nixos/auto.nix`:

- **System updates**: Weekly automatic updates
- **Garbage collection**: Weekly cleanup of packages older than 10 days
- **Store optimization**: Automatic Nix store optimization

### Manual Maintenance

```bash
# Update flake inputs
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d

# Optimize Nix store
sudo nix-store --optimize
```

## Customization

### Adding New Designs (Themes)

To add a new theme:
1. Add your color scheme YAML file to `modules/nixos/themes/` (e.g., `mytheme.yaml`).
2. Add your wallpaper image to `/usr/share/wallpaper/` (e.g., `mytheme.jpg`).
3. Edit `modules/nixos/themes/defaults.nix` to include your new theme:
   ```nix
   mytheme = {
     colorScheme = ./mytheme.yaml;
     wallpaper = "mytheme.jpg";
   };
   ```

### Changing Theme

To change the active theme, edit `flake.nix` and set `activeTheme` to your desired theme (e.g., `themes.mytheme`).

### Adding New Modules

1. Create module file in appropriate directory:
   - System modules: `modules/nixos/`
   - User modules: `modules/home-manager/`
   - Hyprland modules: `modules/hyprland/`

2. Import in the relevant configuration of each host that should use it:
   - System: Add to `hosts/<hostname>/configuration.nix`
   - User: Add to `hosts/<hostname>/home.nix`

### Host Configuration

To add a new host:

1. Create directory: `hosts/<hostname>/`
2. Add required files:
   - `configuration.nix`
   - `hardware-configuration.nix`
   - `home.nix`
3. Add the hostname to the `genAttrs` list in `flake.nix`:
   ```nix
   nixosConfigurations = nixpkgs.lib.genAttrs ["centaur" "orthrus" "<hostname>"] mkHost;
   ```
4. Add the hostname to the `host` matrices in `.github/workflows/build.yml` and `test.yml`

### CI

GitHub Actions evaluate and dry-build every host. Because the `wallpapers` input is an impure local path, `.github/scripts/prepare-wallpapers.sh` creates placeholders for every wallpaper referenced in `modules/nixos/themes/defaults.nix` and patches `flake.lock` to match.
