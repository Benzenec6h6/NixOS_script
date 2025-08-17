{ config, pkgs, ... }:

{
  # ---------------------------------
  # Allow unfree packages
  # ---------------------------------
  nixpkgs.config = {
    allowUnfree = true;
  };

  # ---------------------------------
  # Import modules
  # ---------------------------------
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop.nix
    ./modules/users.nix
    ./modules/networking.nix
  ];

  # ---------------------------------
  # Basic system configuration
  # ---------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "ja_JP.UTF-8";

  users.users.root = {
    password = "rootpassword";  # 安全に設定
  };

  system.stateVersion = "23.05"; # 適宜
}
