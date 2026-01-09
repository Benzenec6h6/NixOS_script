{ pkgs, ... }:

let
  wifiPortalManager = pkgs.writeShellApplication {
    name = "wifi-portal-manager";
    runtimeInputs = [ 
      pkgs.libnotify 
      pkgs.networkmanager 
      pkgs.xdg-utils 
      pkgs.coreutils 
    ];
    # readFile で外部スクリプトを注入
    text = builtins.readFile ./wifi-portal-manager.sh;
  };
in {
  systemd.user.services.wifi-portal-manager = {
    Unit = {
      Description = "Wi-Fi Connectivity and Captive Portal Manager";
      # ネットワーク管理デーモンの後に起動するように設定
      After = [ "network-online.target" "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${wifiPortalManager}/bin/wifi-portal-manager";
      Restart = "always";
      RestartSec = "5";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}