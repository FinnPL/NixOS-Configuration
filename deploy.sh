#!/usr/bin/env bash

set -e

# Deploy the NixOS configuration
nixos-rebuild switch --flake .#centaur

# home-manager
home-manager switch --flake .#centaur