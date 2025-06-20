{ pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    fonts = {
      monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      };
    };
    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      size = 32;
    };
  };
}