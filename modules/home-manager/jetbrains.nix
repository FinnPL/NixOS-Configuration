{ config, pkgs, ... }:

let
  clionWithCopilot = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion [
    "github-copilot"
  ];
in
{
  home.packages = with pkgs; [
    clionWithCopilot
  ];
}
