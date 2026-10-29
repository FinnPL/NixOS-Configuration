{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    texliveFull
    zotero
  ];

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    james-yu.latex-workshop
  ];
}
