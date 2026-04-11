{ config, pkgs, ... }:

{
  # NetworkManager を有効化
  networking.networkmanager = {
    enable = true;
    #wifi.backend = "iwd";

    # DNS を systemd-resolved に任せる（最も安定）
    dns = "systemd-resolved";
    #macアドレスランダム化
    wifi.macAddress = "random";
    wifi.scanRandMacAddress = true;
    #全般的な接続設定
    connectionConfig = {
      "ipv4.dhcp-send-hostname" = false;
      "ipv6.dhcp-send-hostname" = false;
      #"ipv6.ip6-privacy" = 2; # ついでに IPv6 のプライバシーも強化
    };
    # 接続性チェック（キャプティブポータル検知）
    settings = {
      connectivity = {
        uri = "http://nmcheck.gnome.org/check_network_status.txt";
        interval = 300;
      };
      device = {
        "wifi.scan-rand-mac-address" = "yes";
      };
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      DNSStubListener=no
    '';
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    dnsovertls = "opportunistic";
  };

  #networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
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
