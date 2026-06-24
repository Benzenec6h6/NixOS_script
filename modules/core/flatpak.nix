{
  pkgs,
  lib,
  ...
}: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "com.github.tchx84.Flatseal"
      "io.github.dvlv.boxbuddyrs"
      "com.valvesoftware.Steam"
      "com.discordapp.Discord"
      "org.kicad.KiCad"
    ];
    update.onActivation = false;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    restartOnFailure = {
      enable = true;
      restartDelay = "10s"; # 1分待つのは長いので10秒にするなど
      # 必要に応じて指数バックオフを有効化
      exponentialBackoff = {
        enable = true;
        maxDelay = "5m";
      };
    };
  };

  # nix-flatpak が生成するサービスの設定を補強
  systemd.services.flatpak-managed-install = {
    # ネットワークが完全にオンラインになるのを待つ
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };
}
