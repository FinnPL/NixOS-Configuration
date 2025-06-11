{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [ firefox ];

  stylix.targets.firefox.profileNames = [ "fpl" ];

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
