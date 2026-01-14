{ pkgs, ... }:

let
  # 共通の引数(pkgs)を渡してインポートする関数
  importScript = path: import path { inherit pkgs; };
  api = import ./api.nix;
in
{
  imports = [
    ./battery-monitor.nix
    ./storage-monitor.nix
    ./wifi-portal-manager.nix
  ];

  home.sessionVariables = {
    OWM_KEY = api.OWM_KEY;
  };

  home.packages = [
    (importScript ./Brightness.nix)
    (importScript ./ClipManager.nix)
    (importScript ./Dropterminal.nix)
    (importScript ./KeyBinds.nix)
    (importScript ./Volume.nix)
    (importScript ./WaybarCava.nix)
    (importScript ./WaybarScripts.nix)
    (importScript ./Weather.nix)
    (importScript ./recorder.nix)
    (importScript ./ScreenShot.nix)

    # 開発用・無効化中のものはコメントアウトで管理
    # (importScript ./KillActive.nix)
    # (importScript ./networkmanager_rofi.nix)
  ];
}