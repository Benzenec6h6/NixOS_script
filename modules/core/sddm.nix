{ config, pkgs, ... }:

{
  services.displayManager ={
    defaultSession = "hyprland";
    sddm ={
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [pkgs.sddm-astronaut];
      theme = "sddm-astronaut-theme";
    };
  };
}