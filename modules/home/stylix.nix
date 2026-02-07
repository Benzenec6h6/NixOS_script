_: {
  stylix.targets = {
    #gtk.enable = true;
    gtk = {
      enable = true;
      # Stylixの設定と喧嘩しないよう、強制的にダークテーマを優先させる
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };
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
}
