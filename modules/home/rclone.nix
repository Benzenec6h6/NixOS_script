{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.rclone = {
    enable = true;

    requiresUnit = null;

    remotes = {
      mega-vault = {
        config = {
          type = "mega";
          hard_delete = true;
        };

        secrets = {
          user = osConfig.sops.secrets."mega-email".path;
          password = osConfig.sops.secrets."mega-password".path;
        };

        mounts = {
          "" = {
            enable = true;
            autoMount = true;
            mountPoint = "${config.home.homeDirectory}/MEGA";
            options = {
              vfs-cache-mode = "full";
              dir-cache-time = "24h";
              # ここにお好みのオプションを追加
            };
            logLevel = "NOTICE";
          };
        };
      };
    };
  };

  # 【重要】以前の爆走ループを物理的に阻止する設定
  #systemd.user.services.rclone-config.Service.Restart = lib.mkForce "no";
}
