{ config, pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lockCmd = "${pkgs.hyprlock}/bin/hyprlock --config %h/.config/hypr/hyprlock/hyprlock.conf";
        #beforeSleepCmd = "${pkgs.hyprlock}/bin/hyprlock --config %h/.config/hypr/hyprlock/hyprlock.conf";
      };
      listener = [
        { timeout = 1800; on-timeout = "lock"; inhibit_idle = false; }
        { timeout = 2100; on-timeout = "hyprctl dispatch dpms off"; inhibit_idle = false;}
        { timeout = 2700; on-timeout = "systemctl suspend"; inhibit_idle = true; }
      ];
    };
  };
}