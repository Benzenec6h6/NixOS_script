{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "screenshot";
  runtimeInputs = [
    pkgs.hyprland
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.jq
    pkgs.swappy
    pkgs.pipewire   # pw-play用
    pkgs.libnotify
    pkgs.xdg-utils
    pkgs.coreutils
    pkgs.gnused
  ];
  text = builtins.readFile ./ScreenShot.sh;
}