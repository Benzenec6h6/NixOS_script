{ config, pkgs, ... }:

{
  services.displayManager = {
    defaultSession = "hyprland";
    sddm ={
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;

      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtvirtualkeyboard
        qtsvg
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtbase 
    #sddm-astronaut
  ];
}
