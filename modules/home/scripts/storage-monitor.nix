{ pkgs, ... }:

let
  storageMonitor = pkgs.writeShellApplication {
    name = "storage-monitor";
    runtimeInputs = [
      pkgs.libnotify
      pkgs.coreutils
      pkgs.bash
      pkgs.util-linux # lsblk
      pkgs.papirus-icon-theme
    ];
    text = builtins.readFile ./storage.sh;
  };
in
{
  home.packages = [ storageMonitor ];

  systemd.user.services.storage-monitor = {
    Unit = {
      Description = "Removable storage notification";
    };

    Service = {
      Type = "oneshot";
      Environment = "PATH=/run/current-system/sw/bin";
      ExecStart = "${storageMonitor}/bin/storage-monitor";
    };
  };

  systemd.user.timers.storage-monitor = {
    Unit = {
      Description = "Periodic removable storage check";
    };

    Timer = {
      OnBootSec = "10s";
      OnUnitActiveSec = "15s";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
