{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../modules/base.nix
    ../modules/networking.nix
    ../modules/users.nix
    ../modules/services.nix
    ../modules/security.nix
    ../modules/packages.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" "intel" ];
  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    prime = {
      intelBusId = ""; #"PCI:0:2:0"は固有の番号なのでpciutilsで調べる
      nvidiaBusId = ""; #ここも同様
      offload.enable = true;
    };
  };

  # 実機特有の設定
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
