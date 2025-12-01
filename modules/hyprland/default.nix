{...}: {
  imports = [
    ./hyprland-config.nix
    # ./waybar.nix  # Replaced by quickshell
    # ./rofi.nix # Replaced by quickshell overview
    # ./mako.nix   # Replaced by quickshell notifications
    ./hyprpaper.nix
    ./cliphist.nix
    ../quickshell/shell-config.nix
  ];
}
