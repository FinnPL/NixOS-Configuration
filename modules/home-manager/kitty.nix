{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ pkgs.kitty ];
  
  programs.kitty = {
    enable = true;
    font.name = "FantasqueSansMono";
    font.size = 12;
    theme = "Dracula";
  };
}
