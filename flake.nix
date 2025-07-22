{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/Hyprland-Plugins";
      inputs.hyprland.follows = "hyprland";
    };
    wallpapers = {
      url = "path:/usr/share/wallpaper"; # Path to wallpapers directory
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    themes = import ./modules/nixos/themes/defaults.nix;
    activeTheme = themes.valua; # Change this to switch themes
    wallpaperPath = "${inputs.wallpapers}/${activeTheme.wallpaper}";
  in {
    theme = builtins.path {
      path = activeTheme.colorScheme;
      name = "base16-theme";
    };
    wallpaperPath = wallpaperPath;
    nixosConfigurations.centaur = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/centaur/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
