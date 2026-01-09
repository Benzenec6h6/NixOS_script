{ pkgs }:

pkgs.writeShellApplication {
  name = "KeyBinds";
  runtimeInputs = [ 
    pkgs.rofi 
    pkgs.gnugrep 
    pkgs.gnused 
    pkgs.coreutils 
    pkgs.libnotify 
  ];
  # スクリプト内で使うデータの場所を環境変数で渡すと管理しやすいです
  text = ''
    export HYPRLAND_NIX="/etc/nixos/NixOS_script/modules/home/wm/hyprland.nix"
    ${builtins.readFile ./KeyBinds.sh}
  '';
}