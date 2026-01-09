{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "volume";
  runtimeInputs = [ 
    pkgs.pamixer 
    pkgs.libnotify 
    pkgs.wireplumber 
    pkgs.alsa-utils 
    pkgs.coreutils 
    pkgs.gnugrep
  ];
  text = builtins.readFile ./Volume.sh;
}