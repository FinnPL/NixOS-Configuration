{ pkgs, ... }:

{
  home.packages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.clion

    pkgs.openjdk
    pkgs.gcc
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk}";
    PATH = "$PATH:${pkgs.openjdk}/bin:${pkgs.gcc}/bin:${pkgs.jetbrains.idea-ultimate}/bin:${pkgs.jetbrains.pycharm-professional}/bin:${pkgs.jetbrains.clion}/bin";
  };
  programs.zsh.shellAliases = {
    idea = "${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate";
    pycharm = "${pkgs.jetbrains.pycharm-professional}/bin/pycharm-professional";
  };
}