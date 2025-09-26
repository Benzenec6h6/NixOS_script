{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # KDE アプリ群（Plasma-meta に含まれない or 強化したいもの）
    kdePackages.okular      # PDF/ドキュメントビューア
    kdePackages.gwenview    # 画像ビューア
    kdePackages.kate        # エディタ

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
    Celluloid
    qbittorrent
    gparted

    # Virtualization
    qemu-full libvirt virt-viewer OVMF virt-manager
    dnsmasq swtpm libosinfo tuned ntfs-3g
  ];
}
