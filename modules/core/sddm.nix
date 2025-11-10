{ config, pkgs, ... }:

{
  services.displayManager = {
    defaultSession = "hyprland";
    sddm ={
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;   # ← これは「SDDM本体」

      theme = "sddm-astronaut-theme";    # ← テーマ名
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtvirtualkeyboard
        qtsvg
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtbase 
    sddm-astronaut                # ← これは「テーマ」
  ];
}
