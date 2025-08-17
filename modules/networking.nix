{ config, pkgs, ... }:

{
  # ---------------------------------
  # Networking
  # ---------------------------------
  networking.hostName = "my-nixos"; # ホスト名

  # 有線 / 無線
  networking.networkmanager.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  # DHCP / 固定IPは NetworkManager で管理
  networking.useDHCP = true;

  # firewall
  networking.firewall.enable = true;
}
