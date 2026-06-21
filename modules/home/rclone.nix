{
  config,
  pkgs,
  ...
}: {
  programs.rclone = {
    enable = true;

    # 【超重要】ユーザーセッションのsopsサービスを探しに行かないように null を明示
    requiresUnit = null;

    remotes = {
      mega-vault = {
        config = {
          type = "mega";
          hard_delete = true;
          # user はここには書かない！
        };

        # モジュールの「リアルタイムcatインジェクション」機能に全乗っかりする
        secrets = {
          user = "/run/secrets/mega-email";
          password = "/run/secrets/mega-password";
        };

        mounts = {
          "" = {
            enable = true;
            autoMount = true;
            mountPoint = "${config.home.homeDirectory}/MEGA";
            options = {
              dir-cache-time = "24h";
              poll-interval = "1m";
              umask = "0077";
            };
            logLevel = "NOTICE";
          };
        };
      };
    };
  };
}
