{
  config,
  pkgs,
  inputs,
  ...
}: let
  wallpaperPath = inputs.self.wallpaperPath;
in {
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = eDP-1,${wallpaperPath}
  '';
}
