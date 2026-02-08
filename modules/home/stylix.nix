_: {
  stylix.targets = {
    gtk.enable = true;
    waybar.enable = false;
    rofi.enable = true;
    hyprland.enable = false;
    hyprlock.enable = false;
    starship.enable = false;
    firefox.profileNames = [ "main" ];
    qt = {
      enable = true;
      platform = "qtct";
    };
  };
  
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
