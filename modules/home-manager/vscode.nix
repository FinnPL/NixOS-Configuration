{
  config,
  pkgs,
  ...
}: {
  home.file.".vscode/argv.json".text = builtins.toJSON {
    "enable-crash-reporter" = false;
    "password-store" = "gnome-libsecret";
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      #docker.docker
      ms-azuretools.vscode-docker
      #ms-azuretools.vscode-containers
      ms-vscode-remote.remote-containers
      github.vscode-github-actions
      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github
      #eamdio.gitlens
      james-yu.latex-workshop
      #valentjn.vscode-latex
      jnoortheen.nix-ide
    ];
  };
}
