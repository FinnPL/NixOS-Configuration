{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify
  ];

  services.mako = {
    enable = true;
  };
}
