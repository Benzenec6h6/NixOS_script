{ config, pkgs, ... }:

{
  networking.hostName = "nixos"; # hosts/*.nix で上書きしても良い

  # NetworkManager を有効化
  networking.networkmanager.enable = true;

  # Firewall 設定 (ufw or nftables のどちらか)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSHを使う場合のみ
    allowedUDPPorts = [ ];
  };

  # SSH サーバ
  services.openssh.enable = true;
}
