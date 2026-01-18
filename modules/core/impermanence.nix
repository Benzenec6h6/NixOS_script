{ inputs, vars, ... }:

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

  # ユーザーデータの永続化 (Home Manager側)
  home-manager.users.${vars.user.name} = {
    imports = [ inputs.impermanence.homeManagerModules.impermanence ];
    home.persistence."/persist/home/${vars.user.name}" = {
      directories = [
        "Downloads"
        "Desktop"
        "Documents"
        "Music"
        "Pictures"
        "Videos"
        ".ssh"
        ".local/share/direnv"
        ".config/zen-browser"
        ".mozilla/firefox"
      ];
      allowOther = true;
    };
  };
}