{ pkgs, ... }:

{
  home.packages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.clion

    pkgs.openjdk
    pkgs.python3
    pkgs.gcc
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk}";
    PATH = "$PATH:${pkgs.openjdk}/bin:${pkgs.python3}/bin:${pkgs.gcc}/bin:${pkgs.jetbrains.idea-ultimate}/bin:${pkgs.jetbrains.pycharm-professional}/bin:${pkgs.jetbrains.clion}/bin";
  };
}