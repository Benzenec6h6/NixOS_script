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

    tuned.enable = true;

    flatpak.enable = true;

    displayManager.sddm.enable = true;
    #displayManager.sddm.wayland.enable = true;
    #displayManager.sddm.theme = "catppuccin-mocha";

    desktopManager.plasma6.enable = true;
    displayManager.defaultSession = "plasma"; 

    # サウンド (PipeWire + WirePlumber)
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    xserver.enable = true;
    xserver.xkb = {
      layout = "jp";
      variant = "";
    };
  };
  
  programs.xwayland.enable = true;

  #bluetooth
  hardware.bluetooth.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      #libsForQt5.fcitx5-configtool
      #libsForQt5.fcitx5-qt
      kdePackages.fcitx5-configtool
      kdePackages.fcitx5-qt
      fcitx5-mozc-ut
      fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;

    fcitx5.settings.inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "jp";
        DefaultIM = "mozc";
      };
      "Groups/0/Items/0".Name = "keyboard-jp";
      "Groups/0/Items/1".Name = "mozc";
    };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
}
