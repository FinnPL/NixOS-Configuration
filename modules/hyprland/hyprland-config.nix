{
  monitors ? [
    {
      output = "eDP-1";
      mode = "1920x1080@60";
      position = "0x0";
      scale = 1;
    }
  ],
  workspaceRules ? [],
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
  colors = config.lib.stylix.colors;
in {
  home.packages = with pkgs; [
    jq
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    # Hyprland >= 0.57 only reads hyprland.lua
    configType = "lua";

    settings = {
      monitor = monitors;
      workspace_rule = workspaceRules;

      config = {
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vrr = 0; # I Need to switch to DP
        };

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
          "col.active_border" = lib.mkForce {
            colors = ["rgba(${colors.base0D}88)" "rgba(${colors.base0C}88)"];
            angle = 45;
          };
          "col.inactive_border" = lib.mkForce "rgba(${colors.base00}00)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        animations.enabled = true;

        dwindle = {
          preserve_split = true;
        };
      };
    };

    extraConfig = ''
      local mod     = "SUPER"
      local term    = "kitty"
      local browser = "firefox"
      local qs      = "quickshell msg -p ~/.config/quickshell "
      local mos     = "~/.config/hypr/move_or_switch.sh "
      local wpm     = " ${wpm}"

      hl.on("hyprland.start", function()
        hl.exec_cmd("quickshell -p ~/.config/quickshell/shell.qml")
        hl.exec_cmd("wl-paste --watch cliphist store")
        hl.exec_cmd("sleep 3 && vesktop --start-minimized")
      end)

      -- Animations
      hl.curve("winIn",     { type = "bezier", points = { {0.1, 1.0},  {0.1, 1.0}  } })
      hl.curve("winOut",    { type = "bezier", points = { {0.1, 1.0},  {0.1, 1.0}  } })
      hl.curve("smoothOut", { type = "bezier", points = { {0.5, 0},    {0.99, 0.99} } })
      hl.curve("layerOut",  { type = "bezier", points = { {0.23, 1},   {0.32, 1}   } })
      hl.curve("menuPop",   { type = "bezier", points = { {0.1, 1.15}, {0.1, 1.0}  } })

      hl.animation({ leaf = "windowsIn",     enabled = true, speed = 7, bezier = "winIn",     style = "slide" })
      hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })
      hl.animation({ leaf = "windowsMove",   enabled = true, speed = 7, bezier = "winIn",     style = "slide" })
      hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 8, bezier = "winIn",     style = "slide" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 8, bezier = "winOut",    style = "slide" })
      hl.animation({ leaf = "layersIn",      enabled = true, speed = 3, bezier = "menuPop",   style = "popin 80%" })
      hl.animation({ leaf = "layersOut",     enabled = true, speed = 3, bezier = "layerOut",  style = "fade" })

      -- Window rules
      hl.window_rule({ match = { class = "thunar" }, opacity = "0.75 override 0.70 override" })
      for _, class in ipairs({ "firefox", "vesktop", "(gimp|gwenview|ristretto)", "(evince|okular|zathura)", "(vlc|mpv)", "jetbrains" }) do
        hl.window_rule({ match = { class = class }, opacity = "0.98 override 0.98 override" })
      end
      hl.window_rule({ match = { float = true }, animation = "popin 80%" })

      -- Quickshell toggles
      hl.bind("XF86PowerOff",     hl.dsp.exec_cmd(qs .. "session toggle"))
      hl.bind(mod .. " + L",      hl.dsp.exec_cmd(qs .. "lock activate"))
      hl.bind("ALT + Tab",        hl.dsp.exec_cmd(qs .. "overview toggle"))
      hl.bind("ALT + C",          hl.dsp.exec_cmd(qs .. "sidebarRight toggle"))

      -- Overview/App launcher via ALT+SPACE
      hl.bind("ALT + SPACE",      hl.dsp.exec_cmd(qs .. "overview toggle"))

      -- Clipboard via quickshell
      hl.bind(mod .. " + V",      hl.dsp.exec_cmd(qs .. "overview clipboardToggle"))

      -- Terminal, browser & file manager
      hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd(term))
      hl.bind(mod .. " + F",      hl.dsp.exec_cmd(browser))
      hl.bind(mod .. " + E",      hl.dsp.exec_cmd("thunar"))

      -- Move focus to different tile
      hl.bind("ALT + left",       hl.dsp.focus({ direction = "left" }))
      hl.bind("ALT + right",      hl.dsp.focus({ direction = "right" }))
      hl.bind("ALT + up",         hl.dsp.focus({ direction = "up" }))
      hl.bind("ALT + down",       hl.dsp.focus({ direction = "down" }))

      -- Switch between workspaces
      hl.bind(mod .. " + ALT + left",  hl.dsp.exec_cmd(mos .. "switch left" .. wpm))
      hl.bind(mod .. " + ALT + right", hl.dsp.exec_cmd(mos .. "switch right" .. wpm))

      -- Close window with ALT+Q
      hl.bind("ALT + Q",          hl.dsp.window.close())

      -- Move active window (with edge detection)
      for _, dir in ipairs({ "left", "right", "up", "down" }) do
        hl.bind(mod .. " + " .. dir, hl.dsp.exec_cmd(mos .. "move " .. dir .. wpm))
      end

      -- Logout with SUPER+SHIFT+L
      hl.bind(mod .. " + SHIFT + L", hl.dsp.exit())

      -- Resize active window
      hl.bind(mod .. " + CTRL + left",  hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
      hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })
      hl.bind(mod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
      hl.bind(mod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })
    ''
    + lib.optionalString perMonitor ''

      -- Move active window to the adjacent monitor
      hl.bind(mod .. " + SHIFT + left",  hl.dsp.exec_cmd(mos .. "monitor left" .. wpm))
      hl.bind(mod .. " + SHIFT + right", hl.dsp.exec_cmd(mos .. "monitor right" .. wpm))
    '';
  };

  # Keep your bash script as an external executable file exactly as it was
  home.file = {
    ".config/hypr/move_or_switch.sh" = {
      text = builtins.readFile ../../none-nix/hypr/move_or_switch.sh;
      executable = true;
    };
  };
}
