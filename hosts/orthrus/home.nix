{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.username = "fpl";
  home.homeDirectory = "/home/fpl";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../modules/home-manager/basics.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/cli-tools.nix
    ../../modules/home-manager/discord.nix
    (import ../../modules/hyprland/hyprland-config.nix {
      monitorConfig = ''
        # Samsung (left) -> AOC (middle, 144Hz) -> Dell (right)
        monitor = DP-2,1920x1080@60,0x0,1
        monitor = HDMI-A-2,2560x1440@144,1920x0,1
        monitor = DP-1,1280x1024@60,4480x0,1

        # Left monitor: workspaces 1-3
        workspace = 1, monitor:DP-2, default:true
        workspace = 2, monitor:DP-2
        workspace = 3, monitor:DP-2

        # Middle monitor: workspaces 4-6
        workspace = 4, monitor:HDMI-A-2, default:true
        workspace = 5, monitor:HDMI-A-2
        workspace = 6, monitor:HDMI-A-2

        # Right monitor: workspaces 7-9
        workspace = 7, monitor:DP-1, default:true
        workspace = 8, monitor:DP-1
        workspace = 9, monitor:DP-1
      '';
      keyboardLayout = "de";
      keyboardVariant = "";
      enableTouchpad = false;
    })
    ../../modules/hyprland/hyprpaper.nix
    ../../modules/hyprland/cliphist.nix
    ../../modules/quickshell/shell-config.nix
  ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    mangohud
    gamemode
    protonup-qt
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  xdg.configFile."hypr/hyprpaper.conf".text = lib.mkForce ''
    preload = ${inputs.self.wallpaperPath}

    wallpaper {
      monitor = DP-1
      path = ${inputs.self.wallpaperPath}
      fit_mode = cover
    }

    wallpaper {
      monitor = DP-2
      path = ${inputs.self.wallpaperPath}
      fit_mode = cover
    }

    wallpaper {
      monitor = HDMI-A-2
      path = ${inputs.self.wallpaperPath}
      fit_mode = cover
    }
  '';

  programs.home-manager.enable = true;
}
