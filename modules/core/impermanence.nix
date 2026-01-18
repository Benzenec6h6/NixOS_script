{ vars, ... }:

{
  programs.fuse.userAllowOther = true;
  # システム全体の永続化
  environment.persistence."/persist" = {
    hideMounts = true; # マウントを隠してディレクトリを綺麗に保つ
    directories = [
      "/var/log"       # ログを残しておくとトラブルシューティングに役立ちます
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections" # Wi-Fi設定など
    ];
  };
}