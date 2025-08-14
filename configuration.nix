{ config, pkgs, ... }:

{
  ##############################
  # 基本ロケールとタイムゾーン
  ##############################
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8" ];
  time.timeZone = "Asia/Tokyo";

  ##############################
  # フォント
  ##############################
  fonts.fonts = with pkgs; [
    noto-fonts-cjk
  ];

  ##############################
  # 日本語入力 fcitx5 + mozc
  ##############################
  programs.fcitx5.enable = true;
  programs.fcitx5.engines = with pkgs.fcitx-engines; [ mozc ];

  # 環境変数を共通設定
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE  = "fcitx";
    XMODIFIERS    = "@im=fcitx";
  };

  ##############################
  # X11系設定
  ##############################
  services.xserver.enable = true;
  services.xserver.layout = "jp106";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # 試すWMを1つだけ有効化（ここではi3）
  services.xserver.windowManager.i3.enable = true;

  # 他WMはコメントアウトしておく
  # services.xserver.windowManager.openbox.enable = true;
  # services.xserver.windowManager.xfce.enable = true;

  ##############################
  # Wayland系設定（コメントアウト）
  ##############################
  # services.xserver.windowManager.sway.enable = true;
  # services.xserver.windowManager.wayfire.enable = true;

  # fcitx5 Wayland対応モジュール（Waylandを試す場合のみ追加）
  # environment.systemPackages = with pkgs; [
  #   fcitx5-qt
  #   fcitx5-gtk
  # ];

  ##############################
  # ログインマネージャ
  ##############################
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
}
