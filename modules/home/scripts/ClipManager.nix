{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "clipmanager";
  runtimeInputs = [ 
    pkgs.rofi 
    pkgs.cliphist 
    pkgs.wl-clipboard 
    pkgs.procps    # pidof, pkill 用
    pkgs.coreutils 
  ];
  text = builtins.readFile ./ClipManager.sh;
}