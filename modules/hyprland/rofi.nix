{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rofi
    papirus-icon-theme
  ];

  programs.rofi = {
    enable = true;
  };

  # Colors configuration with Stylix colors
  xdg.configFile."rofi/colors.rasi".text = ''
    * {
        background:     #${config.lib.stylix.colors.base00};
        background-alt: #${config.lib.stylix.colors.base01};
        foreground:     #${config.lib.stylix.colors.base05};
        selected:       #${config.lib.stylix.colors.base0D};
        active:         #${config.lib.stylix.colors.base0B};
        urgent:         #${config.lib.stylix.colors.base08};
    }
  '';

  # Main configuration
  xdg.configFile."rofi/adv.rasi".text = ''
    configuration{
        modi: "drun";
        show-icons: true;
        terminal: "kitty";
        drun-display-format: "{icon} {name}";
        location: 0;
        disable-history: false;
        hide-scrollbar: true;
    }
    @theme "~/.config/rofi/menu.rasi"
  '';

  # Menu theme with Stylix colors
  xdg.configFile."rofi/menu.rasi".text = ''
    * {
        width: 600;
        font: "${config.stylix.fonts.monospace.name} 14";
    }
    @import "./colors.rasi"

    element-text, element-icon, mode-switcher {
        background-color: inherit;
        text-color: inherit;
        border-radius: 20px;
        font: @font;
        highlight: none;
    }

    window {
        border: 3px;
        border-color: transparent;
        background-color: @background;
        border-radius: 20px;
        padding: 0px 20px 0px 0px;
        font: @font;
        transparency: "real";
    }

    mainbox {
        background-color: @background;
        font: @font;
    }

    inputbar {
        children: [prompt, entry];
        background-color: @background;
        border-radius: 5px;
        padding: 2px;
        font: @font;
    }

    prompt {
        enabled: false;
        background-color: @selected;
        padding: 5px;
        text-color: @background;
        border-radius: 5px;
        text-align: center;
        margin: 0px;
        font: @font;
    }

    textbox-prompt-colon {
        expand: false;
        str: ":";
        font: @font;
    }

    entry {
        padding: 0px 10px 8px 10px;
        margin: 15px 0px 0px 15px;
        text-color: @foreground;
        background-color: @background;
        line-height: 30px;
        font: @font;
        cursor-width: 11;
    }

    listview {
        border: 0px;
        padding: 4px 0px 13px;
        margin: 0px 0px 0px 20px;
        columns: 1;
        background-color: @background;
        fixed-height: false;
        lines: 10;
        border-radius: 0px;
        font: @font;
    }

    element {
        padding: 8px;
        border-radius: 15px;
        font: @font;
        background-color: @background;
        text-color: @foreground;
        orientation: horizontal;
        children: [element-icon, element-text];
    }

    element-icon {
        enabled: true;
        size: 32px;
        font: @font;
        margin: 0px 10px 0px 0px;
    }

    element selected {
        background-color: @selected;
        border-radius: 15px;
        text-color: @background;
        font: @font;
    }
  '';
}
