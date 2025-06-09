{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ kitty pkgs.nerd-fonts.jetbrains-mono ];
  
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    themeFile = "Dracula";
  };
}