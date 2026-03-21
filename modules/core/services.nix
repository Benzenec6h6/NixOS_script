{ config, pkgs, vars, ... }:

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
    
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
    #power-profiles-daemon.enable = true;
  };
  
  programs.niri.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
      niri = {
        prettyName = "niri";
        comment = "Scrollable-tile Wayland compositor";
        binPath = "/run/current-system/sw/bin/niri";
      };
    };
  };
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
  programs.nix-ld.enable = true;

  #bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  virtualisation.podman.enable = true;
  virtualisation.libvirtd.enable = true;

  environment.pathsToLink = [ 
    "/share/xdg-desktop-portal" 
    "/share/applications" 
  ];
}
