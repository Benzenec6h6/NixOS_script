{ inputs, vars, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/core
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_18;
  services.xserver.videoDrivers = [ "virtio" ];

  # VM特有の設定
  boot.initrd.kernelModules = [ "virtio_pci" "virtio_blk" ];

  # QEMU の guest agent を使う場合など
  services.qemuGuest.enable = true;

  networking.hostName = vars.host;
  system.stateVersion = "25.11";
}
