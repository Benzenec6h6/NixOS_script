{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.rclone = {
    enable = true;

    remotes = {
      mega-vault = {
        config = {
          type = "mega";
          hard_delete = true;
        };

        secrets = {
          user = osConfig.sops.secrets."mega-email".path;
          pass = osConfig.sops.secrets."mega-password".path;
        };

        mounts = {
          "MEGA" = {
            enable = true;
            autoMount = true;
            mountPoint = "${config.home.homeDirectory}/MEGA";
            options = {
              vfs-cache-mode = "full";
              dir-cache-time = "24h";
            };
            logLevel = "NOTICE";
          };
        };
      };
    };
  };

  # 【修正 2】暴走防止セーフティ
  # 失敗時に無限ループせず、数回で諦めるように設定
  systemd.user.services.rclone-config = {
    Unit = {
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3; # 60秒間に3回失敗したら停止
    };
    Service = {
      Restart = lib.mkForce "on-failure";
      RestartSec = "10s"; # 再起動待機時間を設ける
    };
  };
}
