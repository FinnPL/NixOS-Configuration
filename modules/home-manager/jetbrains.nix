{ pkgs, ... }:

{
  home.packages = [
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.clion
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate [
      "github-copilot"
    ])
  ];
}