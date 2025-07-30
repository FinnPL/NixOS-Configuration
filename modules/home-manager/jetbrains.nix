{pkgs, ...}: let
  jetbrainsToolboxWithDesktop = pkgs.symlinkJoin {
    name = "jetbrains-toolbox-with-desktop";
    paths = [pkgs.jetbrains-toolbox];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
            mkdir -p $out/share/applications
            cat > $out/share/applications/jetbrains-toolbox.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=JetBrains Toolbox
      Comment=Manage JetBrains IDEs
      Exec=jetbrains-toolbox
      Icon=jetbrains-toolbox
      Terminal=false
      Categories=Development;IDE;
      EOF
    '';
  };
in {
  home.packages = [
    jetbrainsToolboxWithDesktop
    pkgs.openjdk
    pkgs.kotlin

    pkgs.clang
    pkgs.cmake
    pkgs.gnumake
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk}";
    PATH = "$PATH:${pkgs.openjdk}/bin:${pkgs.gcc}/bin:${pkgs.jetbrains-toolbox}/bin";
  };
}
