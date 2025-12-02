{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    haskell-language-server
    ghc
    cabal-install
    stack
    ormolu
    stylish-haskell
  ];

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    haskell.haskell
  ];
}
