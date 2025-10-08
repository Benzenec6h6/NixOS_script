{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    #libsForQt5.qtstyleplugin-kvantum 
    /*
    gruvbox-kvantum 
    kvmarwaita 
    catppuccin-kvantum 
    rose-pine-kvantum 
    ayu-theme-gtk 
    themechanger 
    */

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
  ];

  fonts.fontconfig.enable = true;
}
