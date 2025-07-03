{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [ kitty ];

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.70";
      dynamic_background_opacity = true;
    };
  };
}