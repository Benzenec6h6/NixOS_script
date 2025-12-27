{ config, pkgs, ... }:

{
  services.hyprpaper.settings = {
    ipc = "on";
    splash = false;

    preload = [
        "$HOME/Pictures/wallpapers/default.png"
    ];

    wallpaper = [
        "eDP-1,$HOME/Pictures/wallpapers/default.png"
    ];
  };
}
