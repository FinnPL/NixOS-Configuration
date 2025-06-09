{ pkgs, ... }:

{
  home.packages = [
    pkgs.thunderbird
  ];
}
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    settings = {
      "mail.server.default.check_new_mail" = true;
      "mail.server.default.auto_download" = false;
      "mail.server.default.auto_download_full" = false;
      "mail.server.default.check_interval" = 10;
      "mail.server.default.notify_on_new_mail" = true;
    };
  };
}