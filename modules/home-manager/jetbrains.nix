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

xdg.desktopEntries = {
  idea-ultimate = {
    name = "IntelliJ IDEA Ultimate";
    exec = "${pkgs.jetbrains.idea-ultimate}/bin/idea.sh";
    icon = "${pkgs.jetbrains.idea-ultimate}/share/pixmaps/idea.png";
    type = "Application";
    categories = [ "Development" "IDE" ];
  };
  clion = {
    name = "CLion";
    exec = "${pkgs.jetbrains.clion}/bin/clion.sh";
    icon = "${pkgs.jetbrains.clion}/share/pixmaps/clion.png";
    type = "Application";
    categories = [ "Development" "IDE" ];
  };
  pycharm-professional = {
    name = "PyCharm Professional";
    exec = "${pkgs.jetbrains.pycharm-professional}/bin/pycharm.sh";
    icon = "${pkgs.jetbrains.pycharm-professional}/share/pixmaps/pycharm.png";
    type = "Application";
    categories = [ "Development" "IDE" ];
  };
};

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk}";
    PATH = "$PATH:${pkgs.openjdk}/bin:${pkgs.python3}/bin:${pkgs.gcc}/bin:${pkgs.jetbrains.idea-ultimate}/bin:${pkgs.jetbrains.pycharm-professional}/bin:${pkgs.jetbrains.clion}/bin";
  };
}