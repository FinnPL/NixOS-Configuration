{ config, pkgs, lib, ... }:

{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atlas.yaml";
}