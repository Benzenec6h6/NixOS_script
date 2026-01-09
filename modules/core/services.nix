{ config, pkgs, ... }:

{
  services = {
    # 時刻同期
    timesyncd.enable = true;

    # CUPS（プリンタ使う場合）
    printing.enable = false;

    # systemd services / extra tweaks
    dbus.enable = true;

    # Avahi (mDNS, AirPrint/AirPlay)
    avahi.enable = false;

    flatpak.enable = true;

    xserver.enable = false;
    xserver.xkb = {
      layout = "jp";
      variant = "";
    };
    xserver.windowManager.xmonad.enable = false;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    #power-profiles-daemon.enable = true;
  };
  
  programs.hyprland.enable = true;
  programs.xwayland.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      exo
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];
  };

  #bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  virtualisation.podman.enable = true;

  virtualisation.libvirtd.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];

  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    settings.auto-optimise-store = true; # 書き込み時に自動で最適化
    # または定期的に最適化したい場合
    optimise.automatic = true;
    optimise.dates = [ "monthly" ];
  };
}
