{
  config,
  pkgs,
  ...
}: let
  myPythonEnv = pkgs.python3.withPackages (ps:
    with ps; [
      numpy
      scipy
      pandas
      plotly
      sympy
      notebook
    ]);
in {
  home.packages = [
    myPythonEnv
  ];

  programs.zsh.shellAliases = {
    jn = "${myPythonEnv}/bin/jupyter notebook";
  };

  home.file.".jupyter/jupyter_notebook_config.py".text = ''
    c.NotebookApp.notebook_dir = "${config.home.homeDirectory}/notebooks"
  '';

  home.activation.createNotebooksDir = ''
    mkdir -p ${config.home.homeDirectory}/notebooks
  '';
}
