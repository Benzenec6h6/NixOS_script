{ config, pkgs, ... }:

{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      #libsForQt5.fcitx5-configtool
      #libsForQt5.fcitx5-qt
      kdePackages.fcitx5-configtool
      kdePackages.fcitx5-qt
      fcitx5-mozc-ut
      fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;

    fcitx5.settings.inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "jp";
        DefaultIM = "mozc";
      };
      "Groups/0/Items/0".Name = "keyboard-jp";
      "Groups/0/Items/1".Name = "mozc";
    };
  };

  environment.systemPackages = [
    (pkgs.runCommand "fcitx5-custom-icons" { } ''
      mkdir -p $out/share/icons/hicolor/scalable/status
      cp ${./input-keyboard-symbolic-svgrepo-com.svg} \
         $out/share/icons/hicolor/scalable/status/input-keyboard-symbolic.svg
      cp ${./mozc-svgrepo-com.svg} \
         $out/share/icons/hicolor/scalable/status/mozc.svg
    '')
  ];
}