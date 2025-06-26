{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
    papirus-icon-theme
  ];

  programs.rofi = {
    enable = true;
  };
  
  xdg.configFile."rofi/template/rounded-template.rasi".source = ../../none-nix/rofi/rounded-template.rasi;
  xdg.configFile."rofi/adv.rasi".text = ''
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
}
