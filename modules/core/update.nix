{ pkgs, vars, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:Benzenec6h6/NixOS_script";
    dates = "daily";

    # これが重要！
    persistent = true; 
  
    randomizedDelaySec = "20min";
    #rebootはこちらでしたいのでoptionは設定しない
  };

  # 更新完了時に通知を送る設定
  systemd.services.nixos-upgrade = {
    serviceConfig.ExecSearchPath = [ pkgs.libnotify pkgs.sudo pkgs.coreutils ];
    # サービスが終了した後に実行する設定
    postStop = ''
      TARGET_USER="${vars.user.name}"
      USER_ID=$(id -u $TARGET_USER)
   
      # 環境変数のセット
      export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USER_ID/bus
      export DISPLAY=:0
   
      # 通知実行（失敗してもサービスを落とさない）
      ${pkgs.sudo}/bin/sudo -u $TARGET_USER \
      DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
      DISPLAY=$DISPLAY \
      ${pkgs.libnotify}/bin/notify-send \
      --icon=system-software-update \
      "システム更新完了" \
      "新しいOSの準備ができました。" || true
    '';
  };
}
