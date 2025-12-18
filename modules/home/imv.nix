{ config, pkgs, ... }:

{
  programs.imv = {
    enable = true;

    # 設定ファイル (~/.config/imv/config) の生成
    settings = {
      options.background = "000000";
      aliases.x = "close";
    };
  };

  # デスクトップエントリ生成（必要）
  xdg.desktopEntries.imv = {
    name = "imv";
    genericName = "Image Viewer";
    comment = "Lightweight image viewer for Wayland/X11";
    exec = "imv %F";
    terminal = false;
    type = "Application";
    mimeType = [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/bmp"
      "image/tiff"
      "image/*"
    ];
    categories = [ "Graphics" "Viewer" ];
  };

  # 画像 MIME をすべて imv に関連づけ
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png"  = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/gif"  = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "image/bmp"  = [ "imv.desktop" ];
      "image/tiff" = [ "imv.desktop" ];
      "image/*"    = [ "imv.desktop" ];
    };
  };
}
