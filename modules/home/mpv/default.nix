{ config, pkgs, ... }:

{
  programs.mpv.enable = true;

  home.file.".config/mpv" = {
    source = ./.;
  };
}
