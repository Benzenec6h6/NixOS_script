{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "brightness";
  runtimeInputs = [ pkgs.brightnessctl pkgs.libnotify pkgs.gawk pkgs.coreutils ];
  text = builtins.readFile ./Brightness.sh;
}