{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    
    wineWowPackages.waylandFull winetricks

    docker

    vscode neovim

    # 通信用
    discord

    # ブラウザ（追加）
    #zen-browser 
    brave

    # ユーティリティ
    steam
    celluloid
    qbittorrent
    gparted

    # Virtualization
    qemu_full libvirt virt-viewer OVMF virt-manager
    dnsmasq swtpm libosinfo tuned ntfs3g
  ];
}
