{
  config,
  pkgs,
  ...
}: {
  programs.rclone = {
    enable = true;

    # 【重要】NixOS側のsops-nixと連携させるための明示的指定
    # これにより、システム側で秘密情報が復号されるのを待ってからrcloneが起動します
    requiresUnit = "sops-nix.service";

    remotes = {
      # リモート名は自由（rclone mount で使う名前になります）
      mega-vault = {
        config = {
          type = "mega";
          user = "tetrodotoxinc11h17n3o8@gmail.com"; # MEGAのメールアドレス
          hard_delete = true; # ゴミ箱を経由せず即時完全削除（MEGAの容量節約に推奨）
        };

        secrets = {
          # NixOS側のsopsが生成したパスを直接指定
          password = "/run/secrets/mega-password";
        };

        mounts = {
          # MEGAのルートディレクトリ全体をマウント
          "" = {
            enable = true;
            autoMount = true;
            # 好きなマウント先（例: ~/Cloud/MEGA）
            mountPoint = "${config.home.homeDirectory}/MEGA";

            options = {
              dir-cache-time = "24h";
              poll-interval = "1m";
              umask = "0077"; # 自分だけが読み書き可能にする安全なパーミッション
            };
            logLevel = "NOTICE";
          };
        };
      };
    };
  };
}
