{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    pavucontrol
    networkmanagerapplet
    brightnessctl
  ];

  programs.waybar = {
    enable = true;
    style = lib.mkForce ''
      * {
          border: none;
          border-radius: 0px;
          font-family: ${config.stylix.fonts.monospace.name};
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: #${config.lib.stylix.colors.base00};
      }

      #cpu, #memory, #custom-brightness {
          background: #${config.lib.stylix.colors.base01};
          color: #${config.lib.stylix.colors.base05};
          border-radius: 24px 10px 24px 10px;
          padding: 0 20px;
          margin: 5px 0;
          font-weight: bold;
          transition: background 0.3s, color 0.3s;
      }

      #cpu:hover, #memory:hover, #custom-brightness:hover {
          background: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base00};
      }

      #battery:hover, #pulseaudio:hover, #network:hover, #clock:hover {
          background: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base00};
      }

      #cava.left, #cava.right {
          background: #${config.lib.stylix.colors.base01};
          margin: 5px; 
          padding: 8px 16px;
          color: #${config.lib.stylix.colors.base0E};
      }
      #cava.left {
          border-radius: 24px 10px 24px 10px;
      }
      #cava.right {
          border-radius: 10px 24px 10px 24px;
      }
      #workspaces {
          background: #${config.lib.stylix.colors.base01};
          margin: 5px 5px;
          padding: 8px 5px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base0E};
      }
      #workspaces button {
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: transparent;
          background: #${config.lib.stylix.colors.base00};
          transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
          background-color: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base00};
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
          transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover {
          background-color: #${config.lib.stylix.colors.base05};
          color: #${config.lib.stylix.colors.base00};
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
      }

      #tray, #pulseaudio, #network, #battery,
      #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward{
          background: #${config.lib.stylix.colors.base01};
          font-weight: bold;
          margin: 5px 0px;
      }
      #tray, #pulseaudio, #network, #battery{
          color: #${config.lib.stylix.colors.base05};
          border-radius: 10px 24px 10px 24px;
          padding: 0 20px;
          margin-left: 7px;
      }
      #clock {
          color: #${config.lib.stylix.colors.base05};
          background: #${config.lib.stylix.colors.base01};
          border-radius: 0px 0px 0px 40px;
          padding: 10px 10px 15px 25px;
          margin-left: 7px;
          font-weight: bold;
          font-size: 16px;
      }
      #custom-launcher {
          color: #${config.lib.stylix.colors.base0D};
          background: #${config.lib.stylix.colors.base01};
          border-radius: 0px 0px 40px 0px;
          margin: 0px;
          padding: 0px 35px 0px 15px;
          font-size: 28px;
      }

      #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward {
          background: #${config.lib.stylix.colors.base01};
          font-size: 22px;
      }
      #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.foward:hover{
          color: #${config.lib.stylix.colors.base05};
      }
      #custom-playerctl.backward {
          color: #${config.lib.stylix.colors.base0E};
          border-radius: 24px 0px 0px 10px;
          padding-left: 16px;
          margin-left: 7px;
      }
      #custom-playerctl.play {
          color: #${config.lib.stylix.colors.base0D};
          padding: 0 5px;
      }
      #custom-playerctl.foward {
          color: #${config.lib.stylix.colors.base0E};
          border-radius: 0px 10px 24px 0px;
          padding-right: 12px;
          margin-right: 7px
      }
      #custom-playerlabel {
          background: #${config.lib.stylix.colors.base01};
          color: #${config.lib.stylix.colors.base05};
          padding: 0 20px;
          border-radius: 24px 10px 24px 10px;
          margin: 5px 0;
          font-weight: bold;
      }
      #window{
          background: #${config.lib.stylix.colors.base01};
          padding-left: 15px;
          padding-right: 15px;
          border-radius: 16px;
          margin-top: 5px;
          margin-bottom: 5px;
          font-weight: normal;
          font-style: normal;
      }
    '';
    settings = lib.importJSON ../../none-nix/waybar/config;
  };
  
  stylix.targets.waybar.enable = false;
}
