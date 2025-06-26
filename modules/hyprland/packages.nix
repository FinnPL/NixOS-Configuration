{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
    rofi
    libnotify 
    playerctl    
    pavucontrol
    hyprpaper
    wl-clipboard
    cliphist
    papirus-icon-theme
    jq
    networkmanagerapplet
  ];
}
