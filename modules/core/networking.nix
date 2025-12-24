{ config, pkgs, ... }:

{
  # NetworkManager を有効化
  networking.networkmanager = {
    enable = true;

    # DNS を systemd-resolved に任せる（最も安定）
    dns = "systemd-resolved";

    # 接続性チェック（キャプティブポータル検知）
    settings = {
      connectivity = {
        enable = true;
        uri = "http://connectivity-check.ubuntu.com";
        interval = 300;
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
