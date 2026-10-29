#!/usr/bin/env bash
# Recreate the impure `wallpapers` flake input (path:/usr/share/wallpaper) on CI.
# Creates a placeholder for every wallpaper referenced by a theme, then points
# flake.lock at the resulting directory so evaluation doesn't fail on a hash mismatch.

set -euo pipefail

WALLPAPER_DIR="/usr/share/wallpaper"

sudo mkdir -p "$WALLPAPER_DIR"

nix eval --raw --impure --expr '
  builtins.concatStringsSep "\n"
    (map (t: t.wallpaper) (builtins.attrValues (import ./modules/nixos/themes/defaults.nix)))
' | while read -r name; do
  echo "Creating placeholder wallpaper: $name"
  echo "placeholder" | sudo tee "$WALLPAPER_DIR/$name" >/dev/null
done

HASH=$(nix hash path "$WALLPAPER_DIR")
NOW=$(stat -c %Y "$WALLPAPER_DIR")
echo "Updating wallpapers lock: lastModified=$NOW, narHash=$HASH"

jq --arg hash "$HASH" --argjson now "$NOW" \
  '.nodes.wallpapers.locked.narHash = $hash | .nodes.wallpapers.locked.lastModified = $now' \
  flake.lock > flake.lock.new
mv flake.lock.new flake.lock
