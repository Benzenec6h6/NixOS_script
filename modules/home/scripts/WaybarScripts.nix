{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "WaybarScripts";
  runtimeInputs = [
    pkgs.kitty
    pkgs.btop
    pkgs.nvtopPackages.full
    pkgs.networkmanager
    pkgs.xfce.thunar
    pkgs.libnotify
    pkgs.coreutils
  ];
  text = builtins.readFile ./WaybarScripts.sh;
}