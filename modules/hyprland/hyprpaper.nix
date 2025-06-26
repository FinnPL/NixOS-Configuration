{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/Pictures/wallpaper.jpg
    wallpaper = eDP-1,${config.home.homeDirectory}/Pictures/wallpaper.jpg
  '';
}
