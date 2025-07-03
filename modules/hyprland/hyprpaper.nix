{ config, pkgs, ... }:
let
  #wallpaperPath = ../../none-nix/wallpapers/203038.jpg;
  wallpaperPath = "${config.home.homeDirectory}/Pictures/wallpaper.png";
in
{
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = eDP-1,${wallpaperPath}
  '';
}
