{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    pavucontrol
    networkmanagerapplet
  ];

  programs.waybar = {
    enable = true;
    style = lib.mkForce ../../none-nix/waybar/style.css;
    settings = lib.importJSON ../../none-nix/waybar/config;
  };
  
  stylix.targets.waybar.enable = false;
}
