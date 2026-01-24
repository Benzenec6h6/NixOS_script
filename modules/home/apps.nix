{ config, pkgs, lib, vars, ... }:
let
  isVM = vars.host == "vm";
  isLaptop = vars.host == "laptop";
in
{
  home.packages = with pkgs; [
    
    #wineWowPackages.waylandFull winetricks

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
    waybar eww #ags
    swww mpvpaper
    pavucontrol #playerctl
    grim slurp wf-recorder wl-clipboard
    swappy sound-theme-freedesktop
    qimgv notify-desktop
  ]
  ++ lib.optionals isLaptop [
      # Virtualization
      qemu_full libvirt virt-viewer OVMF virt-manager
      dnsmasq swtpm libosinfo tuned ntfs3g

      kicad
  ];
}
