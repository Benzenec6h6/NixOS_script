{pkgs, ...}: {
  services.fwupd = {
    enable = true;
    daemonSettings = {
      DisabledPlugins = ["test" "invalid"];

      # もし特定のハードウェアでエラーが出る場合はここに記述
      # DisabledDevices = [ "..." ];

      EspLocation = "/boot";
    };
    extraRemotes = ["lvfs-testing"];
  };

  systemd.services.fwupd-refresh = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
    # ネットワーク接続待ちなどで起動が遅れても、システム切り替えをブロックしない
    wantedBy = ["multi-user.target"];
  };
}
