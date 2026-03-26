{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git
    gh
    fastfetch
    htop
    btop
    traceroute
    wget
    docker
    dysk
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "FinnPL";
      email = "contact@lippok.eu";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "stylix";
    };
  };
}
