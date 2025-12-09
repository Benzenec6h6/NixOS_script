{ config, pkgs, ... }:

{
  networking.hostName = "nixos"; # hosts/*.nix で上書きしても良い

  # NetworkManager を有効化
  networking.networkmanager = {
    enable = true;

    # DNS を systemd-resolved に任せる（最も安定）
    dns = "systemd-resolved";

    # 接続性チェック（キャプティブポータル検知）
    settings = {
      connectivity = {
        enabled = true;
        uri = "http://nmcheck.gnome.org/check";
        #uri = "http://nmcheck.gnome.org/check_network_status.txt";
        response = "OK";
        interval = 5;
      };
    };
  };

  services.resolved.enable = true;
  networking.enableIPv6 = false;

  # Firewall 設定 (ufw or nftables のどちらか)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSHを使う場合のみ
    allowedUDPPorts = [ ];
  };

  # SSH サーバ
  services.openssh.enable = true;
}
