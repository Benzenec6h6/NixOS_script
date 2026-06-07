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
    # 1. 新しい構成に切り替える際、このサービスが「起動に失敗」しても、
    #    nixos-rebuild switch 自体をエラー(Exit 4)にして中断させない魔法のフラグ
    stopIfChanged = false;

    # 2. 構成切り替え時に、このサービスを強制再起動（リロード）の対象から外す
    #    (ネットワークが繋がっていない段階での自爆を防ぐ)
    X-RestartIfChanged = false;
  };
}
