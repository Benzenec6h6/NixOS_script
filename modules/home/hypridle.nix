{ config, pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lockCmd = "hyprlock";
        beforeSleepCmd = "hyprlock";
      };
      listener = [
        { timeout = 1800; on-timeout = "hyprlock"; }
        { timeout = 2700; on-timeout = "systemctl suspend"; }
      ];
    };
  };
}