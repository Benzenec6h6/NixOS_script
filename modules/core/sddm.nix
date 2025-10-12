{ config, pkgs, ... }:

{
  services.displayManager ={
    defaultSession = "hyprland";
    sddm ={
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut";
      package = pkgs.sddm-astronaut;
    };
  };
}