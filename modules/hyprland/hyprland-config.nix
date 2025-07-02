{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
  ];

  home.file.".config/hypr/hyprland.conf".text = ''
    misc {
      disable_hyprland_logo = true
    }
    exec-once = hyprpaper
    exec-once = waybar
    exec-once = mako
    exec-once = wl-paste --watch cliphist store

    monitor = eDP-1,1920x1080@60,0x0,1

    # Set Swiss German keyboard layout and enable natural scrolling
    input {
      kb_layout = ch
      kb_variant = de
      
      touchpad {
        natural_scroll = yes
      }
    }

    dwindle {
      preserve_split = true
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
    bind = ALT, left, movefocus, l
    bind = ALT, right, movefocus, r
    bind = ALT, up, movefocus, u
    bind = ALT, down, movefocus, d

    # Resize window
    bind = $mod+CTRL, left, resizeactive, -30 0
    bind = $mod+CTRL, right, resizeactive, 30 0
    bind = $mod+CTRL, up, resizeactive, 0 -30
    bind = $mod+CTRL, down, resizeactive, 0 30

    # Move between workspaces
    bind = $mod+ALT, left, workspace, -1
    bind = $mod+ALT, right, workspace, +1

    # Close window with ALT+Q
    bind = ALT, Q, killactive, 

    # Move active window (with edge detection)
    bind = $mod, left, exec, ~/.config/hypr/move_or_switch.sh left
    bind = $mod, right, exec, ~/.config/hypr/move_or_switch.sh right
    bind = $mod, up, exec, ~/.config/hypr/move_or_switch.sh up
    bind = $mod, down, exec, ~/.config/hypr/move_or_switch.sh down

    # Logout with SUPER+SHIFT+L
    bind = $mod+SHIFT, L, exec, hyprctl dispatch exit
  '';

  home.file = {
    ".config/hypr/move_or_switch.sh" = {
      text       = builtins.readFile ../../none-nix/hypr/move_or_switch.sh;
      executable = true;
    };
  };
}