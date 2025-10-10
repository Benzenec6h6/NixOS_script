{ config, pkgs, lib, stylix, ... }:

{
  imports = [
    ./hardware.nix
    ../modules/base.nix
    ../modules/networking.nix
    ../modules/users.nix
    ../modules/services.nix
    ../modules/security.nix
    ../modules/packages.nix
    ../modules/stylix.nix
    inputs.stylix.nixosModules.stylix
  ];

  services.xserver.videoDrivers = [ "virtio" ];

  # VM特有の設定
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "virtio_pci" "virtio_blk" ];

  # QEMU の guest agent を使う場合など
  services.qemuGuest.enable = true;
}
