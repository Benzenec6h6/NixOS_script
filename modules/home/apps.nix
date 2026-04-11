{ config, pkgs, inputs, lib, vars, ... }:
let
  isVM = vars.host == "vm";
  isLaptop = vars.host == "laptop";
in
{
  programs.hyprlock.enable = true;
  programs.distrobox.enable = true;
  services.hypridle.enable = true;
  services.blueman-applet.enable = true;
  services.swaync.enable = true;
  services.playerctld.enable = true;
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };
  services.megasync = {
    enable = true;
    forceWayland = true;
  };

  home.packages = [
    inputs.zen-browser.packages.${vars.system}.default
    inputs.moomoo.packages.${vars.system}.default
  ] ++ (with pkgs; [
    vscodium

    # 通信用
    discord

    # ユーティリティ
    steam
    transmission_4-gtk
    qbittorrent
    #gparted

    # 便利ツール
    eww #ags
    swww mpvpaper
    pavucontrol #playerctl
    imagemagick qimgv #notify-desktop
    bottom btop nvtopPackages.full
    qalculate-gtk

    #LSPサーバー
    lua-language-server
    nixd shfmt
  ]
  ++ lib.optionals isLaptop [
      # Virtualization
      virt-viewer virt-manager
      dnsmasq swtpm libosinfo tuned ntfs3g

      kicad-small
  ]);
}
