{ pkgs, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_full; # GUI等フル機能版のQEMU
      swtpm.enable = true;      # TPMエミュレータを有効化
      verbatimConfig = ''
        user = "teto"  # あなたのUID 1000のユーザー名
        group = "libvirtd"
      '';
    };
  };

  services.tuned = {
    enable = true;
    # 基本的な設定
    settings.dynamic_tuning = true;
  };
  
  services.dnsmasq = {
    enable = true;
    
    # 1. このVM自身もdnsmasqをDNSサーバーとして使うようにする
    resolveLocalQueries = true;

    # 2. 詳細な挙動をここに集約して記述する
    settings = {
      resolv-file = "/run/systemd/resolve/resolv.conf";

      # キャッシュするレコード数（デフォルト150を少し増やして効率化）
      cache-size = 1000;

      # 不正なドメイン名（ドットを含まない名前）を上位に転送しない
      domain-needed = true;

      # プライベートIPの逆引きを上位に転送しない
      bogus-priv = true;

      # ローカルネットワーク内での名前解決（例：my-vm.local）
      local = "/local/";
      domain = "local";
      expand-hosts = true;

      #interface = [ "lo" "virbr0" ];
      bind-dynamic = true;
      # ログ設定（トラブルシューティング時に便利。不要ならコメントアウト）
       log-queries = true;
       log-facility = "/var/log/dnsmasq.log";
    };
  };

  # 3. 監視も行いたい場合（Prometheus exporter）
  # services.prometheus.exporters.dnsmasq = {
  #   enable = true;
  #   openFirewall = true; # 監視サーバーからアクセスする場合
  # };
}
