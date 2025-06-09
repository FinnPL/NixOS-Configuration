{ config, pkgs, ... }:

let
  clionWithCopilot =
    pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion [
      pkgs.jetbrains.plugins.github-copilot
    ];
in {
  home.packages = [
    clionWithCopilot
  ];
}
