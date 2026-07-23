{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/nixos/auto.nix
    ../../modules/nixos/stylix-config.nix
    ../../modules/nixos/steam.nix
  ];

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Latest kernel for RDNA 4 support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # GPU CONFIGURATION
  # ============================================================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD GPU drivers
  services.xserver.videoDrivers = ["amdgpu"];

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
    hostName = "orthrus";
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

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  # ============================================================================
  # SERVICES
  # ============================================================================
  services.xserver.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        tuigreet = "${lib.getExe pkgs.tuigreet}";
        baseSessionsDir = "${config.services.displayManager.sessionData.desktops}";
        xSessions = "${baseSessionsDir}/share/xsessions";
        waylandSessions = "${baseSessionsDir}/share/wayland-sessions";
        tuigreetOptions = [
          "--remember"
          "--remember-session"
          "--sessions ${waylandSessions}:${xSessions}"
          "--time"
          "--cmd start-hyprland"
          "--asterisks"
        ];
        flags = lib.concatStringsSep " " tuigreetOptions;
      in {
        command = "${tuigreet} ${flags}";
        user = "fpl";
      };
    };
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.blueman.enable = true;

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "poweroff";
  };

  # ============================================================================
  # HARDWARE
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
    tuigreet
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    git
    claude-code
  ];

  # ============================================================================
  # FONTS
  # ============================================================================
  fonts.packages = with pkgs; [
    material-symbols
    rubik
  ];

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glib
      gtk3
      libGL
      libdrm
      mesa
      libX11
      libXcursor
      libXi
      libXrandr
      libXrender
      libXext
      libXfixes
      libXtst
      libxcb
      freetype
      fontconfig
      libxkbcommon
      wayland
      expat
      nss
      nspr
      dbus
    ];
  };

  system.activationScripts.binbash = {
    text = ''
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
    '';
    deps = [];
  };

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  users.users.fpl = {
    isNormalUser = true;
    description = "FinnPL";
    extraGroups = ["networkmanager" "wheel" "bluetooth"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # ============================================================================
  # HOME MANAGER
  # ============================================================================
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "backup";
    users = {
      "fpl" = import ./home.nix;
    };
  };

  # ============================================================================
  # SYSTEM STATE VERSION
  # ============================================================================
  system.stateVersion = "26.05";
}
