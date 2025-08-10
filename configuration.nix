{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "bedrock-nixos";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.root.initialPassword = "root";

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  console = {
    keyMap = "jp";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}
