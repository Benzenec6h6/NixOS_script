{ config, pkgs, ... }:

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

  services.xserver.videoDrivers = [ "virtio" ];

  # VM特有の設定
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # QEMU の guest agent を使う場合など
  services.qemuGuest.enable = true;
}
