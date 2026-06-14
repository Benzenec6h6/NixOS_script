{pkgs, ...}: let
  wifiPortalAlert = pkgs.writeShellApplication {
    name = "wifi-portal-alert";
    runtimeInputs = [pkgs.libnotify pkgs.networkmanager pkgs.xdg-utils pkgs.coreutils];
    checkPhase = "";
    text = builtins.readFile ./wifi-portal-manager.sh;
  };
in {
  # 1. システム環境にパッケージを登録
  environment.systemPackages = [wifiPortalAlert];

  # 2. NetworkManagerが接続イベントを検知した瞬間にこのスクリプトを実行させる設定
  networking.networkmanager.dispatcherScripts = [
    {
      source = "${wifiPortalAlert}/bin/wifi-portal-alert";
    }
  ];
}
