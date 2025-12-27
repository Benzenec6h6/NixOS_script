{ pkgs, ... }:

let
  batteryMonitor = pkgs.writeShellScriptBin "battery-monitor"
    (builtins.readFile ./battery.sh);
in
{
  home.packages = [ batteryMonitor ];

  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitor notifications";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${batteryMonitor}/bin/battery-monitor";
    };
  };

  systemd.user.timers.battery-monitor = {
    Unit = {
      Description = "Periodic battery check";
    };

    Timer = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
