{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [ firefox ];

  programs.firefox = {
    enable = true;
    profiles.fpl = {
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        proton-vpn
      ];
    };
  };
}
