{ pkgs, data, ... }:

let
  # 渡されたデータをJSONとして書き出す
  keybindsJson = pkgs.writeText "keybinds.json" (builtins.toJSON data);
in
pkgs.writeShellApplication {
  name = "keybind-menu";
  runtimeInputs = [ 
    pkgs.rofi 
    pkgs.jq 
  ];
  # スクリプト内で使うデータの場所を環境変数で渡すと管理しやすいです
  text = ''
    export KEYBINDS_JSON="${keybindsJson}"
    ${builtins.readFile ./keybind-menu.sh}
  '';
}