{pkgs, ...}: let
  jetbrainsToolboxWithDesktop = pkgs.runCommand "jetbrains-toolbox-with-desktop" {
    nativeBuildInputs = [pkgs.makeWrapper];
  } ''
    mkdir -p $out/bin $out/share/applications
    
    # Link the jetbrains-toolbox binary
    ln -s ${pkgs.jetbrains-toolbox}/bin/* $out/bin/
    
    # Copy any existing share directory content (if exists)
    if [ -d "${pkgs.jetbrains-toolbox}/share" ]; then
      cp -rL ${pkgs.jetbrains-toolbox}/share/* $out/share/ 2>/dev/null || true
      chmod -R u+w $out/share/ 2>/dev/null || true
    fi
    
    # Ensure applications directory exists and is writable
    mkdir -p $out/share/applications
    chmod u+w $out/share/applications
    
    # Create the desktop file
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
