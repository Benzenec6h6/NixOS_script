{ config, pkgs, lib, ... }:

let
  # Stylix の base16 カラーパレットを取得
  colors = config.stylix.base16Scheme;

  # 先頭に "#" がない場合は追加しておく
  withHash = c: if lib.hasPrefix "#" c then c else "#" + c;
in
{
  home.file.".config/quickshell/theme.qml".text = ''
    pragma Singleton
    import QtQuick 2.15

    QtObject {
        // Stylixベース16由来のカラースキーム
        property color base00: "${withHash colors.base00}"
        property color base01: "${withHash colors.base01}"
        property color base02: "${withHash colors.base02}"
        property color base03: "${withHash colors.base03}"
        property color base04: "${withHash colors.base04}"
        property color base05: "${withHash colors.base05}"
        property color base06: "${withHash colors.base06}"
        property color base07: "${withHash colors.base07}"
        property color base08: "${withHash colors.base08}"
        property color base09: "${withHash colors.base09}"
        property color base0A: "${withHash colors.base0A}"
        property color base0B: "${withHash colors.base0B}"
        property color base0C: "${withHash colors.base0C}"
        property color base0D: "${withHash colors.base0D}"
        property color base0E: "${withHash colors.base0E}"
        property color base0F: "${withHash colors.base0F}"

        // 推奨UI色
        property color background: base00
        property color surface: base01
        property color text: base05
        property color accent: base0D
        property color border: base03
    }
  '';

  home.file.".config/quickshell/overview.qml".source = ./overview.qml;
}
