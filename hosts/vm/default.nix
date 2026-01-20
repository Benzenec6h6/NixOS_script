{ inputs, vars, host, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/core
  ];

  services.xserver.videoDrivers = [ "virtio" ];

  # VM特有の設定
  boot.initrd.kernelModules = [ "virtio_pci" "virtio_blk" ];

  # QEMU の guest agent を使う場合など
  services.qemuGuest.enable = true;

  networking.hostName = host;
  system.stateVersion = "25.11";
}
