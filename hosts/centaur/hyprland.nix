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
    jq
  ];
  # 1) Enable Hyprland itself
  wayland.windowManager.hyprland = {
    enable = true;

    # 4) Add Rofi and test keybindings via extraConfig
    extraConfig = ''
      misc {
        disable_hyprland_logo = true
      }
      exec-once = hyprpaper
      exec-once = waybar
      exec-once = mako

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
  };

home.file = {
    ".config/hypr/move_or_switch.sh" = {
      text       = builtins.readFile ../../none-nix/hypr/move_or_switch.sh;
      executable = true;
    };
  };
  
  programs.waybar = {
    enable = true;
    style = lib.mkForce ../../none-nix/waybar/style.css;
    settings = lib.importJSON ../../none-nix/waybar/config;
  };
  stylix.targets.waybar.enable = false;

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
