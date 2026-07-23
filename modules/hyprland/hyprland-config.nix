{
  monitorConfig ? "monitor = eDP-1,1920x1080@60,0x0,1",
  keyboardLayout ? "ch",
  keyboardVariant ? "de",
  enableTouchpad ? true,
  workspacesPerMonitor ? null,
}: {
  config,
  pkgs,
  lib,
  ...
}: let
  wpm = toString (
    if workspacesPerMonitor == null
    then 0
    else workspacesPerMonitor
  );
  perMonitor = workspacesPerMonitor != null;
in {
  home.packages = with pkgs; [
    jq
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    configType = "hyprlang";

    settings = {
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 0; # I Need to switch to DP
      };

      exec-once = [
        "quickshell -p ~/.config/quickshell/shell.qml"
        "wl-paste --watch cliphist store"
        "sleep 3 && vesktop --start-minimized"
      ];

      input =
        {
          kb_layout = keyboardLayout;
          kb_variant = keyboardVariant;
        }
        // lib.optionalAttrs enableTouchpad {
          touchpad = {
            natural_scroll = true;
          };
        };

      decoration = {
        rounding = 10;
        inactive_opacity = 0.75;
        active_opacity = 0.85;

        blur = {
          enabled = true;
          size = 1;
          passes = 5;
          vibrancy = 0.1696;
          new_optimizations = true;
        };
      };

      general = {
        border_size = 2;
        "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0D}88) rgba(${config.lib.stylix.colors.base0C}88) 45deg";
        "col.inactive_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base00}00)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      animations = {
        enabled = true;

        bezier = [
          "winIn, 0.1, 1.0, 0.1, 1.0"
          "winOut, 0.1, 1.0, 0.1, 1.0"
          "smoothOut, 0.5, 0, 0.99, 0.99"
          "layerOut, 0.23, 1, 0.32, 1"
          "menuPop, 0.1, 1.15, 0.1, 1.0"
        ];

        animation = [
          "windowsIn, 1, 7, winIn, slide"
          "windowsOut, 1, 3, smoothOut, slide"
          "windowsMove, 1, 7, winIn, slide"
          "workspacesIn, 1, 8, winIn, slide"
          "workspacesOut, 1, 8, winOut, slide"
          "layersIn, 1, 7, winIn, slide"
          "layersOut, 1, 3, layerOut, slide"
          "layersIn, 1, 3, menuPop, popin 80%"
          "layersOut, 1, 3, layerOut, fade"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      # Window rules (new v0.52 syntax)
      windowrule = [
        "opacity 0.75 override 0.70 override, match:class thunar"
        "opacity 0.98 override 0.98 override, match:class firefox"
        "opacity 0.98 override 0.98 override, match:class vesktop"
        "opacity 0.98 override 0.98 override, match:class (gimp|gwenview|ristretto)"
        "opacity 0.98 override 0.98 override, match:class (evince|okular|zathura)"
        "opacity 0.98 override 0.98 override, match:class (vlc|mpv)"
        "opacity 0.98 override 0.98 override, match:class jetbrains"

        "animation popin 80%, match:float 1"
      ];

      # Variables
      "$mod" = "SUPER";
      "$term" = "kitty";
      "$browser" = "firefox";

      bind =
        [
          # Quickshell toggles
          ", XF86PowerOff, exec, quickshell msg -p ~/.config/quickshell session toggle"
          "$mod, L, exec, quickshell msg -p ~/.config/quickshell lock activate"
          "ALT, Tab, exec, quickshell msg -p ~/.config/quickshell overview toggle"
          "ALT, C, exec, quickshell msg -p ~/.config/quickshell sidebarRight toggle"

          # Overview/App launcher via ALT+SPACE
          "ALT, SPACE, exec, quickshell msg -p ~/.config/quickshell overview toggle"

          # Clipboard via quickshell
          "$mod, V, exec, quickshell msg -p ~/.config/quickshell overview clipboardToggle"

          # Terminal & browser
          "$mod, SPACE, exec, $term"
          "$mod, F, exec, $browser"

          # Open Thunar with WIN+E
          "$mod, E, exec, thunar"

          # Move focus to different tile
          "ALT, left, movefocus, l"
          "ALT, right, movefocus, r"
          "ALT, up, movefocus, u"
          "ALT, down, movefocus, d"

          # Switch between workspaces
          "$mod+ALT, left, exec, ~/.config/hypr/move_or_switch.sh switch left ${wpm}"
          "$mod+ALT, right, exec, ~/.config/hypr/move_or_switch.sh switch right ${wpm}"

          # Close window with ALT+Q
          "ALT, Q, killactive,"

          # Move active window (with edge detection)
          "$mod, left, exec, ~/.config/hypr/move_or_switch.sh move left ${wpm}"
          "$mod, right, exec, ~/.config/hypr/move_or_switch.sh move right ${wpm}"
          "$mod, up, exec, ~/.config/hypr/move_or_switch.sh move up ${wpm}"
          "$mod, down, exec, ~/.config/hypr/move_or_switch.sh move down ${wpm}"

          # Logout with SUPER+SHIFT+L
          "$mod+SHIFT, L, exec, hyprctl dispatch exit"
        ]
        ++ lib.optionals perMonitor [
          # Move active window to the adjacent monitor
          "$mod+SHIFT, left, exec, ~/.config/hypr/move_or_switch.sh monitor left ${wpm}"
          "$mod+SHIFT, right, exec, ~/.config/hypr/move_or_switch.sh monitor right ${wpm}"
        ];

      binde = [
        "$mod+CTRL, left, resizeactive, -30 0"
        "$mod+CTRL, right, resizeactive, 30 0"
        "$mod+CTRL, up, resizeactive, 0 -30"
        "$mod+CTRL, down, resizeactive, 0 30"
      ];
    };

    extraConfig = monitorConfig;
  };

  # Keep your bash script as an external executable file exactly as it was
  home.file = {
    ".config/hypr/move_or_switch.sh" = {
      text = builtins.readFile ../../none-nix/hypr/move_or_switch.sh;
      executable = true;
    };
  };
}
