{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # ============================================================================
  # IMPORTS
  # ============================================================================
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/nixos/auto.nix
    ../../modules/nixos/stylix-config.nix
  ];

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # HYPRLAND CONFIGURATION
  # ============================================================================
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # ============================================================================
  # NETWORK CONFIGURATION
  # ============================================================================
  networking = {
    hostName = "centaur";
    networkmanager.enable = true;
  };

  # ============================================================================
  # LOCALIZATION
  # ============================================================================
  time.timeZone = "Europe/Berlin";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Keyboard configuration
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };
  console.keyMap = "sg";

  # ============================================================================
  # SERVICES CONFIGURATION
  # ============================================================================
  
  # X11 Services
  services.xserver.enable = true;
  
  # Display Manager (Greetd)
  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
        baseSessionsDir = "${config.services.displayManager.sessionData.desktops}";
        xSessions = "${baseSessionsDir}/share/xsessions";
        waylandSessions = "${baseSessionsDir}/share/wayland-sessions";
        tuigreetOptions = [
          "--remember"
          "--remember-session"
          "--sessions ${waylandSessions}:${xSessions}"
          "--time"
          "--cmd Hyprland"
          "--asterisks"
        ];
        flags = lib.concatStringsSep " " tuigreetOptions;
      in {
        command = "${tuigreet} ${flags}";
        user = "fpl";
      };
    };
  };

  # Printing
  services.printing.enable = true;

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # D-Bus
  services.dbus.enable = true;

  # GNOME Services
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # ============================================================================
  # HARDWARE CONFIGURATION
  # ============================================================================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ============================================================================
  # SECURITY & PAM
  # ============================================================================
  security.pam.services.greetd.enableGnomeKeyring = true;

  # ============================================================================
  # DESKTOP PORTALS
  # ============================================================================
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  programs.zsh.enable = true;

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  users.users.fpl = {
    isNormalUser = true;
    description = "fpl";
    extraGroups = ["networkmanager" "wheel" "bluetooth"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # ============================================================================
  # HOME MANAGER
  # ============================================================================
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "fpl" = import ./home.nix;
    };
  };

  # ============================================================================
  # SYSTEM STATE VERSION
  # ============================================================================
  system.stateVersion = "25.05";
}
