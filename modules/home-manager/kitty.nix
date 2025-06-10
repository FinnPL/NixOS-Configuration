{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ kitty nerd-fonts.jetbrains-mono ];

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      foreground            = "#${config.colorScheme.palette.base05}";
      background            = "#${config.colorScheme.palette.base00}";
      selection_foreground  = "#${config.colorScheme.palette.base01}";
      selection_background  = "#${config.colorScheme.palette.base06}";
      cursor                = "#${config.colorScheme.palette.base05}";

      color0                = "#${config.colorScheme.palette.base00}";
      color1                = "#${config.colorScheme.palette.base08}";
      color2                = "#${config.colorScheme.palette.base0B}";
      color3                = "#${config.colorScheme.palette.base0A}";
      color4                = "#${config.colorScheme.palette.base0D}";
      color5                = "#${config.colorScheme.palette.base0E}";
      color6                = "#${config.colorScheme.palette.base0C}";
      color7                = "#${config.colorScheme.palette.base05}";
      color8                = "#${config.colorScheme.palette.base03}";
      color9                = "#${config.colorScheme.palette.base08}";
      color10               = "#${config.colorScheme.palette.base0B}";
      color11               = "#${config.colorScheme.palette.base0A}";
      color12               = "#${config.colorScheme.palette.base0D}";
      color13               = "#${config.colorScheme.palette.base0E}";
      color14               = "#${config.colorScheme.palette.base0C}";
      color15               = "#${config.colorScheme.palette.base07}";
    };
  };
}