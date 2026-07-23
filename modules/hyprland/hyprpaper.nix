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
    splash = false
    preload = ${wallpaperPath}

    wallpaper {
      monitor =
      path = ${wallpaperPath}
      fit_mode = cover
    }
  '';
}
