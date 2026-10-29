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
      # Samsung (left) -> AOC (middle, 144Hz) -> Dell (right)
      monitors = [
        {
          output = "DP-2";
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        }
        {
          output = "HDMI-A-2";
          mode = "2560x1440@144";
          position = "1920x0";
          scale = 1;
        }
        {
          output = "DP-1";
          mode = "1280x1024@60";
          position = "4480x0";
          scale = 1;
        }
      ];
      # Left: workspaces 1-4, middle: 5-8, right: 9-12
      workspaceRules = lib.concatLists (lib.imap0 (i: monitor:
        lib.genList (j: {
          workspace = toString (i * 4 + j + 1);
          inherit monitor;
          default = j == 0;
        })
        4) ["DP-2" "HDMI-A-2" "DP-1"]);
      keyboardLayout = "de";
      keyboardVariant = "";
      enableTouchpad = false;
      workspacesPerMonitor = 4;
    })
    ../../modules/hyprland/hyprpaper.nix
    ../../modules/hyprland/cliphist.nix
    (import ../../modules/quickshell/shell-config.nix {
      # Each monitor owns 4 workspaces, so each bar shows a group of 4.
      workspacesShown = 4;
      # Label every monitor's workspaces 1-4 (indexed by global id - 1).
      workspaceNumberMap = ["1" "2" "3" "4" "1" "2" "3" "4" "1" "2" "3" "4"];
    })
  ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [];

  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = 141;
      fps = true;
      frametime = true;
      gpu_stats = true;
      gpu_temp = true;
      cpu_stats = true;
      cpu_temp = true;
      vram = true;
      ram = true;
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
    MOZ_LEGACY_PROFILES = "1";
  };

  programs.home-manager.enable = true;
}
