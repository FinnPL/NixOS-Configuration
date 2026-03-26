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

    wallpaper {
      monitor = eDP-1
      path = ${wallpaperPath}
      fit_mode = cover
    }
  '';
}
