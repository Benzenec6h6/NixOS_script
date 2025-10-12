{ config, pkgs, ... }:

{
  services.displayManager ={
    defaultSession = "hyprland";
    sddm ={
      enable = true;
      wayland.enable = true;
      extraPackages = [pkgs.sddm-astronaut];
      theme = "sddm-astronaut";
    };
  };
}