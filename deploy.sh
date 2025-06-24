#!/usr/bin/env bash

set -euo pipefail

# Variables
FLAKE_PATH="."
HOST="centaur"

# Check for required commands
command -v nixos-rebuild >/dev/null 2>&1 || { echo "nixos-rebuild not found."; exit 1; }

# Update flake inputs
echo "Updating flake inputs..."
nix flake update --flake "$FLAKE_PATH"

# Deploy the NixOS configuration
echo "Rebuilding and switching to new configuration..."
sudo nixos-rebuild switch --flake "$FLAKE_PATH#$HOST"

echo "Deployment complete."