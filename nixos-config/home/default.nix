{ config, pkgs, ... }:

{
  imports = [
    ./all
  ];

  home = {
    username = "jon";
    homeDirectory = "/home/jon";

    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}