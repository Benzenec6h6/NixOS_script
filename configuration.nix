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
    ./modules/networking.nix
    <home-manager/nixos>  # ← Home Manager モジュールを追加
    ./home/teto.nix
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

  programs.zsh.enable = true;
  users.users.teto = {
    isNormalUser = true;
    home = "/home/teto";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" ];
    shell = pkgs.zsh;
  };

  # sudo 権限
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.05"; # 適宜
}
