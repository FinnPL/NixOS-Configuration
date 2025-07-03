{ config, pkgs, ... }:

{
  # Core desktop applications
  home.packages = with pkgs; [
    # Bluetooth management
    blueman
    
    # File manager with improved functionality
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.thunar-media-tags-plugin
    
    # Thumbnail generation for file managers
    xfce.tumbler  # Main thumbnail service
    ffmpegthumbnailer  # Video thumbnails
    
    # Icon themes for better appearance
    papirus-icon-theme
    adwaita-icon-theme
    
    # Image format support
    webp-pixbuf-loader
    librsvg  # SVG support
    
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

  # GTK configuration for better theming
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Transparency CSS using stylix
  stylix.targets.gtk.extraCss = ''
    /* Thunar transparency overrides */
    .thunar-window {
      background-color: alpha(@theme_bg_color, 0.70);
    }
    
    .thunar-window .view {
      background-color: alpha(@theme_base_color, 0.70);
    }
    
    .thunar-window .sidebar {
      background-color: alpha(@theme_bg_color, 0.70);
    }
    
    /* General window transparency for GTK3 apps */
    window {
      background-color: alpha(@theme_bg_color, 0.85);
    }
    
    .background {
      background-color: alpha(@theme_bg_color, 0.85);
    }
  '';
}