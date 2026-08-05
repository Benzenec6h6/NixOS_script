{
  pkgs,
  lib,
  ...
}: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "com.github.tchx84.Flatseal"
      "io.github.dvlv.boxbuddyrs"
      "com.valvesoftware.Steam"
      "com.discordapp.Discord"
      "org.kicad.KiCad"
    ];
    update.onActivation = false;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    restartOnFailure = {
      enable = true;
      restartDelay = "10s";
      exponentialBackoff = {
        enable = true;
        maxDelay = "5m";
      };
    };
  };

  # nix-flatpak が生成するサービスの設定を調整
  systemd.services.flatpak-managed-install = {
    # wants から network-online.target を外す（これで wait-online が起動時に呼び出されなくなる）
    # 代わりに「もし network-online が動いているならその後に実行する」という順序関係だけ残す
    after = lib.mkForce [];
    wants = lib.mkForce []; # 明示的に上書きして強制削除

    # ネットワーク未接続で rebuild してもエラー（Exit 1）で rebuild 全体を止めないようにする配慮
    # （必要に応じて：一時的なネットワーク失敗なら restartOnFailure に任せてリトライさせます）
  };
}
