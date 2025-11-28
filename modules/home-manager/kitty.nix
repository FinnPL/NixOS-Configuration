{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [kitty];

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.70";
      dynamic_background_opacity = true;

      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
    };
  };
}
