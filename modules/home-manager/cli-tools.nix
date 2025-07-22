{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git
    gh
    neofetch
    htop
    btop
    traceroute
    wget
    docker
    dysk
  ];

  programs.git = {
    enable = true;
    userName = "FinnPL";
    userEmail = "contact@lippok.eu";
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "stylix";
    };
  };
}
