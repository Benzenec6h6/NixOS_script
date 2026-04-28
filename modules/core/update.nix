{ pkgs, ... }:
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
    script = pkgs.lib.mkAfter ''
      # サービスが正常終了した（ExitCode=0）かつ、何らかの変更があった場合に通知
      # (operation = "boot" の場合、成功すれば自動的にここに到達します)
      
      # 通知を送るためのスクリプト
      # デスクトップ通知(libnotify)を利用
      ${pkgs.libnotify}/bin/notify-send \
        --urgency=normal \
        --icon=system-software-update \
        "システム更新が完了しました" \
        "新しいバージョンが準備できました。都合の良い時に再起動してください。"
    '';
  };
}
