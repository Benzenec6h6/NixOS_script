{ config, pkgs, lib, ... }:

{
  stylix.targets = {
    gtk.enable = true;
    waybar.enable = false;
    rofi ={
      enable = true;
      package = pkgs.rofi;
    };
    hyprland.enable = false;
    hyprlock.enable = false;
    starship.enable = false;
    qt = {
      enable = true;
      platform = "qtct";
    };
  };
}
