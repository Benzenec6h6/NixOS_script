{ config, pkgs, lib, inputs, vars, host ? "laptop", ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/core
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
      intelBusId = vars.busId.intel;
      nvidiaBusId = vars.busId.nvidia;
      offload.enable = true;
    };
  };

  boot.initrd.postDeviceCommands = lib.mkAfter (builtins.readFile ./rollback.sh);
  networking.hostName = host;
  system.stateVersion = "25.11";
}
