{ config, pkgs, ... }:

{
  home.file.".config/mpv" = {
    source = ./.;
  };
}
