# NixOS Configuration
[![Test NixOS Configuration](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/test.yml/badge.svg)](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/test.yml)
[![Evaluate NixOS Configuration](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/build.yml/badge.svg)](https://github.com/FinnPL/NixOS-Configuration/actions/workflows/build.yml)

My NixOS configuration using flakes with Hyprland, Home Manager, and modular structure.

## Overview

This repository contains a complete NixOS configuration featuring:
- **Hyprland** - Modern Wayland compositor
- **Home Manager** - Declarative user environment management  
- **Stylix** - System-wide theming
- **Modular structure** - Clean separation of concerns

## Quick Start

### Prerequisites
- NixOS installed with flakes enabled
- Git for cloning this repository

### Installation

1. Clone this repository:
```bash
git clone https://github.com/FinnPL/nixos-config /etc/nixos
cd /etc/nixos
```

2. Deploy the configuration:
```bash
chmod +x deploy.sh
./deploy.sh
```

3. To update flake inputs before deployment:
```bash
./deploy.sh -up
```

## Architecture

### Flake Structure

The configuration is built using Nix flakes with the following inputs:
- **nixpkgs** - Latest unstable channel
- **home-manager** - User environment management
- **firefox-addons** - Firefox extensions via NUR
- **stylix** - System-wide theming framework
- **hyprland** - Wayland compositor and plugins

### Directory Structure

```
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked input versions
├── deploy.sh                    # Deployment script
├── hosts/                       # Host-specific configurations
│   └── centaur/
│       ├── configuration.nix    # System configuration
│       ├── hardware-configuration.nix  # Hardware settings
│       └── home.nix             # User configuration
├── modules/                     # Modular configurations
│   ├── home-manager/           # User-level modules
│   ├── hyprland/              # Hyprland-specific modules
│   └── nixos/                 # System-level modules
└── none-nix/                   # Non-Nix configuration files
```

## Module System

### Home Manager Modules

Located in `modules/home-manager/`:

- **basics.nix** - Essential packages and settings
- **cli-tools.nix** - Command-line utilities
- **discord.nix** - Discord configuration
- **firefox.nix** - Firefox with extensions
- **jetbrains.nix** - JetBrains IDE suite
- **kitty.nix** - Terminal emulator configuration
- **python-packages.nix** - Python development environment
- **thunderbird.nix** - Email client
- **vscode.nix** - Visual Studio Code setup
- **zsh.nix** - Zsh shell configuration

### Hyprland Modules

Located in `modules/hyprland/`:

- **default.nix** - Main Hyprland configuration
- **hyprland-config.nix** - Window manager settings
- **waybar.nix** - Status bar configuration
- **rofi.nix** - Application launcher
- **mako.nix** - Notification daemon
- **hyprpaper.nix** - Wallpaper management
- **cliphist.nix** - Clipboard history

### NixOS Modules

Located in `modules/nixos/`:

- **auto.nix** - Automatic updates and cleanup
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

### Adding New Modules

1. Create module file in appropriate directory:
   - System modules: `modules/nixos/`
   - User modules: `modules/home-manager/`
   - Hyprland modules: `modules/hyprland/`

2. Import in relevant configuration:
   - System: Add to `hosts/centaur/configuration.nix`
   - User: Add to `hosts/centaur/home.nix`

### Host Configuration

To add a new host:

1. Create directory: `hosts/<hostname>/`
2. Add required files:
   - `configuration.nix`
   - `hardware-configuration.nix`
   - `home.nix`
3. Update `flake.nix` to include new host
