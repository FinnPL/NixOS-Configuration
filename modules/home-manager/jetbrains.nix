{ pkgs, ... }:

{
  home.packages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.clion
  ];
}