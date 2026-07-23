{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;

    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        desiredgov = "performance";
      };
    };
  };

  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    protonup-qt
    protontricks
  ];
}
