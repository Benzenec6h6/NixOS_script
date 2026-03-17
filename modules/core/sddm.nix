{ config, pkgs, ... }:

let
  astronautTheme = pkgs.callPackage ./build.nix {};
in
{
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
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
    astronautTheme 
    #sddm-astronaut
  ];
}
