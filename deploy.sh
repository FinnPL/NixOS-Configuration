#!/usr/bin/env bash

set -euo pipefail

# Variables
FLAKE_PATH="."
HOST="$(hostname)"

# Check for required commands
command -v nixos-rebuild >/dev/null 2>&1 || { echo "nixos-rebuild not found."; exit 1; }

# Parse arguments: ./deploy.sh [-up] [host]
UPDATE=0
for arg in "$@"; do
    case "$arg" in
        -up) UPDATE=1 ;;
        -*) echo "Unknown option: $arg"; exit 1 ;;
        *) HOST="$arg" ;;
    esac
done

# Format Nix files
if command -v nix >/dev/null 2>&1; then
    echo "Formatting Nix files with nix fmt..."
    nix fmt "$FLAKE_PATH"
fi

# Update flake inputs if -up flag is passed
if [[ $UPDATE -eq 1 ]]; then
    echo "Updating flake inputs..."
    nix flake update --flake "$FLAKE_PATH"
fi

# Deploy the NixOS configuration
echo "Rebuilding and switching to new configuration..."
sudo nixos-rebuild switch --flake "$FLAKE_PATH#$HOST"

echo "Deployment complete."

# Reload Hyprland configuration
if command -v hyprctl >/dev/null 2>&1; then
    echo "Reloading Hyprland configuration..."
    hyprctl reload
fi