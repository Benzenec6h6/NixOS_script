{ pkgs, inputs, vars, lib, ... }:

let
  # 共通の引数(pkgs)を渡してインポートする関数
  importScript = path: import path { inherit pkgs inputs vars; };
  hyprlandKeyData = import ../hyprland/keybinddata.nix { inherit lib vars; };
in
{
  imports = [
    ./battery-monitor.nix
    ./storage-monitor.nix
    ./wifi-portal-manager.nix
  ];

  home.packages = [
    (importScript ./Brightness.nix)
    (importScript ./ClipManager.nix)
    (importScript ./Dropterminal.nix)
    (import ./keybind-menu.nix { 
      inherit pkgs; 
      data = hyprlandKeyData;
    })
    (importScript ./recorder.nix)
    (importScript ./ScreenShot.nix)
    (importScript ./Thaw.nix)
    (importScript ./Volume.nix)
    (importScript ./WaybarCava.nix)
    (importScript ./WaybarScripts.nix)
    (importScript ./Weather.nix)

    # 開発用・無効化中のものはコメントアウトで管理
    # (importScript ./KillActive.nix)
    # (importScript ./networkmanager_rofi.nix)
  ];
}
