{ config, pkgs, inputs, username, profile, ... }:

{
  imports = [
    ./hardware.nix
    ../modules/core
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    prime = {
      intelBusId = ""; #"PCI:0:2:0"は固有の番号なのでpciutilsで調べる
      nvidiaBusId = ""; #ここも同様
      offload.enable = true;
    };
  };

  networking.hostName = "laptop";

}
