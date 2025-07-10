{
  config,
  pkgs,
  ...
}: {
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

    decoration {
      rounding = 10

      # Enable transparency/blur
      blur {
        enabled = true
        size = 1
        passes = 5
        vibrancy = 0.1696
        new_optimizations = true
      }
    }

    animations {
    enabled = true, animations
        bezier = winIn, 0.1, 1.0, 0.1, 1.0
        bezier = winOut, 0.1, 1.0, 0.1, 1.0
        bezier = smoothOut, 0.5, 0, 0.99, 0.99
        bezier = layerOut,0.23,1,0.32,1
        animation = windowsIn, 1, 7, winIn, slide
        animation = windowsOut, 1, 3, smoothOut, slide
        animation = windowsMove, 1, 7, winIn, slide
        animation = workspacesIn, 1, 8, winIn, slide
        animation = workspacesOut, 1, 8, winOut, slide
        animation = layersIn, 1, 10, winIn, slide
        animation = layersOut, 1, 3, layerOut, popin 50%
    }

    dwindle {
      preserve_split = true
    }

    # Window rules
    windowrule=opacity 0.92 override 0.85 override, class:^(thunar)$

    $mod = SUPER
    $term = kitty
    $browser = firefox

    # Rofi toggle on Alt+Space
    bind = ALT, SPACE, exec, pkill rofi || rofi -show drun -no-config -theme-str '@theme "${config.home.homeDirectory}/.config/rofi/adv.rasi"'
    bind = $mod, V, exec, pkill rofi || (cliphist list | rofi -dmenu | cliphist decode | wl-copy)

    # Terminal & browser
    bind = $mod, SPACE, exec, $term
    bind = $mod, F, exec, $browser

    # Open Thunar with WIN+E
    bind = $mod, E, exec, thunar

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
      text = builtins.readFile ../../none-nix/hypr/move_or_switch.sh;
      executable = true;
    };
  };
}
