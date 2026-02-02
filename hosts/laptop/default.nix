{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/core
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_18;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };
  
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    prime = {
      intelBusId = vars.busId.intel;
      nvidiaBusId = vars.busId.nvidia;
      offload.enable = true;
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
  
  boot.initrd.postDeviceCommands = lib.mkAfter (builtins.readFile ./rollback.sh);
  networking.hostName = vars.host;
  system.stateVersion = "25.11";
}
