{ config, pkgs, ... }:

{
  # パッケージ: Plasma 6 デスクトップ
  home.packages = with pkgs.kdePackages; [
    kdeconnect
    plasma-browser-integration
  ];

  # Plasmaセッションを有効化するための設定
  xsession.enable = true;

  # GTK/Qt の統合テーマ (任意)
  gtk.enable = true;
  qt.enable = true;

  home.stateVersion = "25.05"; # flakeのチャンネルに合わせる
}
