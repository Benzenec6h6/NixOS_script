{ vars, ... }:

{
  programs.fuse.userAllowOther = true;
  fileSystems."/home".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
  # システム全体の永続化
  environment.persistence."/persist" = {
    hideMounts = true; # マウントを隠してディレクトリを綺麗に保つ
    directories = [
      "/var/log"       # ログを残しておくとトラブルシューティングに役立ちます
      "/var/lib/sbctl"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/flatpak"
      "/etc/NetworkManager/system-connections" # Wi-Fi設定など
      "/etc/ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
