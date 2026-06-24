{
  config,
  pkgs,
  inputs,
  lib,
  vars,
  ...
}: let
  isVM = vars.host == "vm";
  isLaptop = vars.host == "laptop";
in {
  programs.hyprlock.enable = true;
  programs.distrobox.enable = true;
  services.tailscale-systray.enable = true;
  services.hypridle.enable = true;
  services.blueman-applet.enable = true;
  services.swaync.enable = true;
  services.playerctld.enable = true;
  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };
  #As of May 2026, there is a bug where `QWindow` remains `NULL` when calling `QmlDialogWrapperBase::show()`.
  #I guess we'll just have to wait for the upstream fix.
  services.megasync = {
    enable = false;
    forceWayland = true;
  };

  home.packages =
    [
      inputs.zen-browser.packages.${vars.system}.default
      inputs.moomoo.packages.${vars.system}.default
      inputs.rust-tools.packages.${vars.system}.default
    ]
    ++ (with pkgs;
      [
        # 通信用
        #discord

        # ユーティリティ
        #steam
        transmission_4-gtk
        #qbittorrent
        #gparted

        # 便利ツール
        eww #ags
        awww
        mpvpaper
        pavucontrol #playerctl
        imagemagick
        qimgv
        bottom
        btop
        nvtopPackages.full
        qalculate-gtk
        #megacmd

        #LSPサーバー
        lua-language-server
        nixd
        shfmt
      ]
      ++ lib.optionals isLaptop [
        ntfs3g

        #kicad-small
      ]);
}
