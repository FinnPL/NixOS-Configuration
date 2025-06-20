{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [ 
    rofi 
    libnotify 
    playerctl    
    pavucontrol
  ];
  # 1) Enable Hyprland itself
  wayland.windowManager.hyprland = {
    enable = true;

    # 4) Add Rofi and test keybindings via extraConfig
    extraConfig = ''
      exec-once = kitty
      exec-once = waybar
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
      bind = ALT, SPACE, exec, pkill rofi || rofi -show drun

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
    '';
  };
  
  programs.waybar = {
    enable = true;
    style = ../../none-nix/waybar/style.css;
    settings = lib.importJSON ../../none-nix/waybar/config;
  };

  # 2) Enable and install Rofi
  programs.rofi = {
    enable = true;
  };

}
