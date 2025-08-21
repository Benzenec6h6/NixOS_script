{ config, pkgs, ... }:

{
  # Networking
  networking.hostName = "my-nixos"; # ホスト名

  # 有線 / 無線
  networking.networkmanager.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  # firewall
  networking.firewall.enable = true;
}
