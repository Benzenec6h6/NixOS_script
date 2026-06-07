{pkgs, ...}: {
  services.fwupd = {
    enable = true;
    daemonSettings = {
      DisabledPlugins = ["test" "invalid"];
      EspLocation = "/boot";
    };
    extraRemotes = ["lvfs-testing"];
  };

  # ★ 公式の systemd.packages 経由のロードを、手元から完全にコントロールする
  systemd.services.fwupd-refresh = {
    # 1. 新構成への切り替え時、このサービスを強制再起動の対象から外す
    restartIfChanged = false;

    # 2. 変更があった場合でも、古いサービスを停止させない
    stopIfChanged = false;
  };
}
