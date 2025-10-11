{ inputs, username, profile, ... }:

{
  imports = [
    ./hardware.nix
    ../modules/core/base.nix
    ../modules/core/networking.nix
    ../modules/core/users.nix
    ../modules/core/services.nix
    ../modules/core/security.nix
    ../modules/core/packages.nix
    ../modules/core/stylix.nix
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
