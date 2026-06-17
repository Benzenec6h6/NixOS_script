{
  pkgs,
  inputs,
  ...
}: {
  systemd.user.services.wifi-portal-watch = {
    Unit = {
      Description = "Wi-Fi Captive Portal Watcher";
      # 1. グラフィカルセッションが整い
      # 2. 通知サーバー(swaync)が立ち上がり
      # 3. ネットワーク機能が利用可能になった後
      After = ["graphical-session.target" "swaync.service" "network.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.rust-tools}/bin/wifi-portal-watch";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
