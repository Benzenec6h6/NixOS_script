{ config, pkgs, lib, vars, ... }:
let
  isVM = vars.host == "vm";
  isLaptop = vars.host == "laptop";
in
{
  home.packages = with pkgs; [
 
    transmission_4-gtk

    vscodium

    # 通信用
    discord

    # ブラウザ（追加）
    #zen-browser 

    # ユーティリティ
    steam
    qbittorrent
    gparted

    # 便利ツール
    eww #ags
    swww mpvpaper
    pavucontrol #playerctl
    sound-theme-freedesktop
    qimgv notify-desktop
    qalculate-gtk
  ]
  ++ lib.optionals isLaptop [
      # Virtualization
      qemu_full libvirt virt-viewer OVMF virt-manager
      dnsmasq swtpm libosinfo tuned ntfs3g

      kicad
  ];
}
