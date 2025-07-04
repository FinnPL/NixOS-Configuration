{pkgs, ...}: {
  home.packages = [
    pkgs.vesktop
  ];

  stylix.targets.vesktop.enable = true;
}
