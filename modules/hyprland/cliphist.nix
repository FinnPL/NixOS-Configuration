{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];

  systemd.user.services.cliphist-store = {
    Unit = {
      Description = "Cliphist clipboard storage";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "always";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
