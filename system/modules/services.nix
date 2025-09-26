{ config, pkgs, ... }:

{
  services = {
    # 時刻同期
    timesyncd.enable = true;

    # ssh サーバ（必要なら）
    openssh.enable = false;

    # CUPS（プリンタ使う場合）
    printing.enable = false;

    #bluetooth
    hardware.bluetooth.enable = true;

    hardware.cpu.intel.updateMicrocode = true;

    # サウンド (PipeWire + WirePlumber)
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    xserver = {
      enable = true;
      layout = "jp";
      xkbVariant = "";
    };
  };

  # systemd services / extra tweaks
  services.dbus.enable = true;

  # Avahi (mDNS, AirPrint/AirPlay)
  services.avahi.enable = false;

  services.tuned.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;

  services.flatpak.enable = true;

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
  xdg.portal.extraPortals = [ kdePackages.xdg-desktop-portal-kde ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.theme = "catppuccin-mocha";

  # Wayland を優先 (Plasma 6 は Wayland がデフォルト)
  wayland.windowManager.plasma6.enable = true;
}
