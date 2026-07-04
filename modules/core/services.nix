{pkgs, ...}: {
  services = {
    # 時刻同期
    timesyncd.enable = true;

    # CUPS（プリンタ使う場合）
    printing.enable = false;

    # systemd services / extra tweaks
    dbus.enable = true;

    # Avahi (mDNS, AirPrint/AirPlay)
    avahi.enable = false;

    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
    #power-profiles-daemon.enable = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      #hyprland = {
      #  prettyName = "Hyprland";
      #  binPath = "/run/current-system/sw/bin/start-hyprland";
      #};
      niri = {
        prettyName = "niri";
        comment = "Scrollable-tile Wayland compositor";
        binPath = "/run/current-system/sw/bin/niri";
      };
    };
  };
  programs.xwayland.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-ld.enable = true;

  #bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
