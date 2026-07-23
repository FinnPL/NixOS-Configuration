{
  config,
  pkgs,
  inputs,
  ...
}: {
  stylix.targets.firefox = {
    enable = true;
    profileNames = ["fpl"];
    colorTheme.enable = true;
  };

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.fpl = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.page" = 3;
      };
      extensions.force = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        proton-vpn
      ];
    };
  };
}
