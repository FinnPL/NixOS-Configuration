{ config, pkgs, lib, ... }:

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
  ];
  # 1) Enable Hyprland itself
  wayland.windowManager.hyprland = {
    enable = true;

    # 4) Add Rofi and test keybindings via extraConfig
    extraConfig = ''
      exec-once = kitty
      exec-once = waybar
      exec-once = mako
      exec-once = hyprpaper
      monitor = eDP-1,1920x1080@60,0x0,1

      # Set Swiss German keyboard layout
      input {
        kb_layout = ch
        kb_variant = de
      }

      $mod = SUPER
      $term = kitty
      $browser = firefox

      # Rofi toggle on Alt+Space
      bind = ALT, SPACE, exec, pkill rofi || rofi -show drun -no-config -theme-str '@theme "${config.home.homeDirectory}/.config/rofi/adv.rasi"'
      bind = $mod, V, exec, pkill rofi || (cliphist list | rofi -dmenu | cliphist decode | wl-copy)


      # Terminal & browser
      bind = $mod, SPACE, exec, $term
      bind = $mod, F, exec, $browser

      # Move focus to different tile
      bind = CTRL, left, movefocus, l
      bind = CTRL, right, movefocus, r
      bind = CTRL, up, movefocus, u
      bind = CTRL, down, movefocus, d

      # Resize window
      bind = ALT, left, resizeactive, -20 0
      bind = ALT, right, resizeactive, 20 0
      bind = ALT, up, resizeactive, 0 -20
      bind = ALT, down, resizeactive, 0 20

      # Move between workspaces
      bind = $mod+ALT, left, workspace, -1
      bind = $mod+ALT, right, workspace, +1

      # Close window with ALT+Q
      bind = ALT, Q, killactive, 

      # Move active window
      bind = $mod, left, movewindow, l
      bind = $mod, right, movewindow, r
      bind = $mod, up, movewindow, u
      bind = $mod, down, movewindow, d

      # Move active window to previous/next workspace with CTRL+SUPER+Left/Right
      bind = CTRL+$mod, left, movetoworkspace, -1
      bind = CTRL+$mod, right, movetoworkspace, +1

      # Logout with SUPER+SHIFT+L
      bind = $mod+SHIFT, L, exec, hyprctl dispatch exit

    '';
  };
  
  programs.waybar = {
    enable = true;
    style = lib.mkForce ../../none-nix/waybar/style.css;
    settings = lib.importJSON ../../none-nix/waybar/config;
  };

  # 2) Enable and install Rofi
  programs.rofi = {
    enable = true;
  };
  xdg.configFile."rofi/template/rounded-template.rasi".source = ../../none-nix/rofi/rounded-template.rasi;
  xdg.configFile."rofi/adv.rasi".text =''
  * {
    bg0:    #${config.lib.stylix.colors.base00};
    bg1:    #${config.lib.stylix.colors.base01};
    bg2:    #${config.lib.stylix.colors.base02}CC;
    bg3:    #${config.lib.stylix.colors.base0D}F2;
    fg0:    #${config.lib.stylix.colors.base05};
    fg1:    #${config.lib.stylix.colors.base06};
    fg2:    #${config.lib.stylix.colors.base05};
    fg3:    #${config.lib.stylix.colors.base03};
  }

  configuration {
    icon-theme: "Papirus";
    show-icons: true;
  }


    @import "template/rounded-template.rasi"

    element selected {
        text-color: @bg1;
    }
  '';

  services.mako = {
    enable = true;
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/Pictures/wallpaper.jpg
    wallpaper = eDP-1,${config.home.homeDirectory}/Pictures/wallpaper.jpg
  '';

  systemd.user.services.cliphist-store = {
    Unit.Description = "Cliphist clipboard storage";
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
    };
    Install.WantedBy = [ "default.target" ];
  };


}
