{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = inputs.self.theme;
    image = inputs.self.wallpaperPath;
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
    # Allow home-manager to override GTK CSS
    targets.gtk.enable = true;
  };
}
