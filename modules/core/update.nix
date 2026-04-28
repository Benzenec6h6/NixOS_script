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
  # サービスが終了した後に実行する設定
  postStop = ''
    # 1. あなたのユーザー名（ここを書き換えてください）
    TARGET_USER="${vars.user.name}" 
    
    # 2. サービスが正常終了（success）した時だけ通知を出す
    if [ "$SERVICE_RESULT" = "success" ]; then
      USER_ID=$(id -u $TARGET_USER)
      
      # ユーザーのデスクトップ環境に接続するための設定
      export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USER_ID/bus
      
      ${pkgs.sudo}/bin/sudo -u $TARGET_USER \
        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
        ${pkgs.libnotify}/bin/notify-send \
        --icon=system-software-update \
        "システム更新完了" \
        "新しいOSの準備ができました。再起動で反映されます。"
    fi
  '';
};
}
