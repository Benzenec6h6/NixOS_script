{ config, pkgs, lib, ... }:

{
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;

    # 必要な unfree パッケージだけを許可
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "cudatoolkit"
      "cuda-merged"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Import modules
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop.nix
    ./modules/networking.nix
  ];

  # Basic system configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";

  users.users.root = {
    password = "rootpassword";  # 最初のログイン後変更する
  };

  home-manager.users.teto = import ./home/teto.nix;
  users.users.teto = {
    isNormalUser = true;
    initialPassword = "userpassword";
    home = "/home/teto";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" ];
  };

  # sudo 権限
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.05"; # 適宜
}
