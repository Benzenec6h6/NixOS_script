{ ... }: {
  xdg.autostart.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # 画像は qimgv
      "image/png"  = [ "qimgv.desktop" ];
      "image/jpeg" = [ "qimgv.desktop" ];
      "image/webp" = [ "qimgv.desktop" ];
      "image/gif"  = [ "qimgv.desktop" ];
      "image/bmp"  = [ "qimgv.desktop" ];

      # Web / URL は zen
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http"  = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];

      "x-scheme-handler/magnet" = [ "transmission-gtk.desktop" ];
      "application/x-bittorrent" = [ "transmission-gtk.desktop" ];
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland 
    ];

    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      };
    };
  };
}