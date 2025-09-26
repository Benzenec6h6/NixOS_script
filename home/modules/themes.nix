{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kvantum

    # GTK/Qt テーマ
    catppuccin-gtk
    catppuccin-kde
    gruvbox-gtk-theme
    gruvbox-material-gtk-theme
    plata-theme
    materia-theme
    nordic
    dracula-theme
    adwaita-qt

    # アイコンテーマ
    material-icons
    papirus-icon-theme
    epapirus-icon-theme
    tela-icon-theme
    beauty-line-icon-theme
    whitesur-icon-theme
    dracula-icon-theme

    #カーソル
    material-cursors
    gruppled-white-cursors
    gruppled-black-cursors
    catppuccin-cursors
    capitaine-cursors-themed

    # フォント
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    font-awesome
  ];

  # GTK テーマ設定 (Catppuccin をデフォルトに)
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark";
      package = pkgs.catppuccin-cursors;
    };
  };

  # Qt 側の設定 (Kvantum + GTK fallback)
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme = "gtk"; # GTK と統一
  };

  # Kvantum 設定を XDG に書き込み（Catppuccinをデフォルトに）
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Catppuccin-Mocha-Blue
  '';

  fonts.fontconfig.enable = true;
}
