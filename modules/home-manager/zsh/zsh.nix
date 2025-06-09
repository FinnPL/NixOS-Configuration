{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ pure-prompt ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [ "git" "z" "sudo" "gh" ];
    };
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      # Set up pure prompt
      fpath+="${pkgs.pure-prompt}/share/zsh/site-functions"
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };
}
