{ pkgs, vars, ... }:
let
  # 選択されたターミナルパッケージを特定
  termPkg = if vars.user.terminal == "kitty" then pkgs.kitty else pkgs.ghostty;
  # 実行コマンド名
  termCmd = vars.user.terminal;
in
pkgs.writeShellApplication {
  name = "WaybarScripts";
  runtimeInputs = [
    termPkg
    pkgs.btop
    pkgs.nvtopPackages.full
    pkgs.networkmanager
    pkgs.xfce.thunar
    pkgs.libnotify
    pkgs.coreutils
  ];
  text = ''
    termcmd = "''${termCmd}"
    builtins.readFile ./WaybarScripts.sh
  '';
}
