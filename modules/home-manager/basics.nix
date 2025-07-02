{ config, pkgs, ... }:

{
  # Core desktop applications
  home.packages = with pkgs; [
    # Bluetooth management
    blueman
    
    # File manager
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    
    evince  # GNOME document viewer
    loupe # GNOME image viewer (formerly eog)

    vlc
    seahorse  # GNOME keyring/password manager
  ];

  # Services configuration
  services = {
    # Bluetooth applet
    blueman-applet.enable = true;
  };

  # Enable GNOME keyring
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };
}