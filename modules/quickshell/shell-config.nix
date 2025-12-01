{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Get quickshell from flake input directly (not from nixpkgs overlay)
  quickshellPkg = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Qt packages needed for QML imports
  qtDeps = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtquicktimeline
    qt6.qtsensors
    qt6.qtsvg
    qt6.qttools
    qt6.qttranslations
    qt6.qtvirtualkeyboard
    qt6.qtwayland
    kdePackages.kirigami.unwrapped # Use unwrapped to get actual QML files
    kdePackages.syntax-highlighting
  ];

  # Build QML import paths from Qt dependencies
  qmlImportPaths = lib.concatMapStringsSep ":" (pkg: "${pkg}/lib/qt-6/qml") qtDeps;

  # Wrap quickshell with QML import paths
  quickshellWrapped = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = [quickshellPkg];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --prefix QML2_IMPORT_PATH : "${qmlImportPaths}" \
        --prefix QML_IMPORT_PATH : "${qmlImportPaths}"
    '';
  };

  # Get stylix colors from the config
  colors = config.lib.stylix.colors;

  # Generate the Material Design colors JSON from Stylix base16 colors
  colorsJson =
    pkgs.runCommand "quickshell-colors.json" {
      nativeBuildInputs = [pkgs.python3];
      BASE00 = colors.base00;
      BASE01 = colors.base01;
      BASE02 = colors.base02;
      BASE03 = colors.base03;
      BASE04 = colors.base04;
      BASE05 = colors.base05;
      BASE06 = colors.base06;
      BASE07 = colors.base07;
      BASE08 = colors.base08;
      BASE09 = colors.base09;
      BASE0A = colors.base0A;
      BASE0B = colors.base0B;
      BASE0C = colors.base0C;
      BASE0D = colors.base0D;
      BASE0E = colors.base0E;
      BASE0F = colors.base0F;
    } ''
      ${pkgs.python3}/bin/python3 ${./generate-colors.py} $out
    '';

  # Font configuration
  fontFamily = config.stylix.fonts.monospace.name;

  # Quickshell config directory
  quickshellConfigDir = ./config;

  # Generate the illogical-impulse config.json as a file in the nix store
  illogicalImpulseConfig = pkgs.writeText "illogical-impulse-config.json" (builtins.toJSON {
    # Minimal set of panels for better performance
    enabledPanels = [
      "iiBar"
      "iiLock"
      "iiNotificationPopup"
      "iiOnScreenDisplay"
      "iiOverview"
      "iiSessionScreen"
      "iiSidebarRight"
    ];
    panelFamily = "ii";
    policies = {};
    appearance = {
      extraBackgroundTint = true;
      fakeScreenRounding = 2;
      fonts = {
        main = fontFamily;
        numbers = fontFamily;
        title = fontFamily;
        iconNerd = fontFamily;
        monospace = fontFamily;
        reading = fontFamily;
        expressive = fontFamily;
      };
      transparency = {
        enable = true;
        automatic = false;
        backgroundTransparency = 0.15;
        contentTransparency = 0.45;
      };
      wallpaperTheming = {
        enableAppsAndShell = false;
        enableQtApps = false;
        enableTerminal = false;
      };
      palette = {
        type = "auto";
      };
    };
    apps = {
      bluetooth = "blueman-manager";
      network = "kitty nmtui";
      networkEthernet = "nm-connection-editor";
      taskManager = "kitty htop";
      terminal = "kitty";
      update = "kitty --hold sudo nixos-rebuild switch";
      volumeMixer = "pavucontrol";
    };
    background = {
      widgets = {
        clock = {
          enable = true;
          showOnlyWhenLocked = false;
          placementStrategy = "leastBusy";
          x = 100;
          y = 100;
          style = "cookie";
          styleLocked = "cookie";
          cookie = {
            aiStyling = false;
            sides = 14;
            dialNumberStyle = "full";
            hourHandStyle = "fill";
            minuteHandStyle = "medium";
            secondHandStyle = "dot";
            dateStyle = "bubble";
            timeIndicators = true;
            hourMarks = false;
            dateInClock = true;
            constantlyRotate = false;
            useSineCookie = false;
          };
          digital = {
            animateChange = true;
          };
          quote = {
            enable = false;
            text = "";
          };
        };
        weather = {
          enable = false;
          placementStrategy = "free";
          x = 400;
          y = 100;
        };
      };
      wallpaperPath = "";
      thumbnailPath = "";
      hideWhenFullscreen = true;
      parallax = {
        vertical = false;
        autoVertical = false;
        enableWorkspace = true;
        workspaceZoom = 1.07;
        enableSidebar = true;
        widgetsFactor = 1.2;
      };
    };
    bar = {
      autoHide = {
        enable = false;
        hoverRegionWidth = 2;
        pushWindows = false;
        showWhenPressingSuper = {
          enable = true;
          delay = 140;
        };
      };
      bottom = false;
      cornerStyle = 0;
      floatStyleShadow = true;
      borderless = false;
      topLeftIcon = "distro";
      showBackground = true;
      verbose = true;
      vertical = false;
      resources = {
        alwaysShowSwap = true;
        alwaysShowCpu = true;
        memoryWarningThreshold = 95;
        swapWarningThreshold = 85;
        cpuWarningThreshold = 90;
      };
      screenList = [];
      utilButtons = {
        showScreenSnip = true;
        showColorPicker = false;
        showMicToggle = false;
        showKeyboardToggle = false;
        showDarkModeToggle = false;
        showPerformanceProfileToggle = false;
        showScreenRecord = false;
      };
      weather = {
        enable = true;
        enableGPS = false;
        city = "Aachen";
        useUSCS = false;
        fetchInterval = 10;
      };
    };
    dock = {
      enable = false;
    };
    hacks = {
      arbitraryRaceConditionDelay = 100;
    };
    interactions = {
      deadPixelWorkaround = {
        enable = false;
      };
    };
    notifications = {
      location = "topRight";
      silentAtNight = false;
      silentAtNightFrom = "22:00";
      silentAtNightTo = "08:00";
    };
    overview = {
      scale = 0.15;
    };
    search = {
      enableFeatures = {
        actions = true;
        aiChat = false;
        apps = true;
        commands = true;
        files = true;
        math = true;
        translate = false;
        web = true;
      };
      maxResults = 10;
    };
    sidebar = {
      left = {
        autoOpenWhenIdle = false;
        autoOpenWhenIdleDelay = 300;
        autoOpenWhenIdleOnBattery = false;
        pages = ["home" "notifications"];
      };
      right = {
        pages = ["calendar" "quickToggles"];
      };
    };
    time = {
      secondPrecision = true;
      format = {
        clock = "HH:mm";
        date = "ddd, MMM d";
      };
    };
  });
in {
  # Install quickshell (wrapped with QML paths) and dependencies
  home.packages = with pkgs; [
    quickshellWrapped
    # Dependencies for the shell scripts
    jq
    socat
    playerctl
    pamixer
    brightnessctl
    wl-clipboard
    cliphist
    grim
    slurp
    libnotify
    # Screenshot tools
    imagemagick
    swappy
    tesseract
    # Power management
    upower
    ddcutil
    # For icons - only use papirus to avoid conflicts
    papirus-icon-theme
    # Note: Material Symbols and Rubik fonts are installed system-wide in configuration.nix
    # Additional utilities
    hyprpicker
    # Calculator for search
    libqalculate
    # Audio visualizer
    cava
    # Secret storage (for keyring)
    libsecret
    # Music recognition
    songrec
    ffmpeg
    pulseaudio
    # Night light / blue light filter
    hyprsunset
  ];

  # Install fonts via fonts.fontconfig to ensure they're available system-wide
  fonts.fontconfig.enable = true;

  # Create the quickshell configuration
  xdg.configFile = {
    # Main quickshell config directory
    "quickshell" = {
      source = quickshellConfigDir;
      recursive = true;
    };
  };

  # Generate the colors.json file that quickshell reads
  home.file.".local/state/quickshell/user/generated/colors.json".source = colorsJson;

  # Create required directories and copy mutable config files
  home.activation.quickshellSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create required directories
    mkdir -p $HOME/.local/state/quickshell/user/generated
    mkdir -p $HOME/.config/illogical-impulse/translations
    mkdir -p $HOME/.cache/quickshell/notifications

    # Copy illogical-impulse config if it doesn't exist (makes it writable for quickshell)
    if [ ! -f "$HOME/.config/illogical-impulse/config.json" ]; then
      cp ${illogicalImpulseConfig} $HOME/.config/illogical-impulse/config.json
      chmod 644 $HOME/.config/illogical-impulse/config.json
    fi

    # Create empty en_US.json translation file if it doesn't exist
    if [ ! -f "$HOME/.config/illogical-impulse/translations/en_US.json" ]; then
      echo '{}' > $HOME/.config/illogical-impulse/translations/en_US.json
    fi
  '';
}
