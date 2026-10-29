{
  config,
  pkgs,
  ...
}: {
  # Zotero bundles its own Firefox ESR runtime, which nixpkgs marks as insecure
  nixpkgs.config.permittedInsecurePackages = [
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];

  home.packages = with pkgs; [
    texliveFull
    zotero
  ];

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    james-yu.latex-workshop
  ];
}
