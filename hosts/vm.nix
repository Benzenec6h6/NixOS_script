{ inputs, username, profile, ... }:

{
  imports = [
    ./hardware.nix
    ../modules/core/fcitx5-mozc
    ../modules/core/scripts
    ../modules/core/sddm
    ../modules/core/base.nix
    #../modules/core/greetd.nix
    ../modules/core/hibernate.nix
    ../modules/core/networking.nix
    ../modules/core/packages.nix
    ../modules/core/power-management.nix
    ../modules/core/quickshell.nix
    ../modules/core/security.nix
    ../modules/core/services.nix
    ../modules/core/stylix.nix
    ../modules/core/users.nix
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
