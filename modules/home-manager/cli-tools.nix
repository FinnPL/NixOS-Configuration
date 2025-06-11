{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    gh
    neofetch
    htop
    traceroute
    wget
    docker
  ];

  programs.git = {
     enable = true;
     userName = "FinnPL";
     userEmail = "contact@lippok.eu";
  };
}