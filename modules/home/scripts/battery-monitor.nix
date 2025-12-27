{ config, pkgs, lib, ... }:

let
  batteryMonitor = pkgs.writeShellScriptBin "battery-monitor" ''
    ${builtins.readFile ./battery.sh}
  '';
in
{
  systemd.user.services.battery-monitor = {
    description = "Battery monitor notifications";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${batteryMonitor}/bin/battery-monitor";
    };
  };

  systemd.user.timers.battery-monitor = {
    enable = true;
    description = "Periodic battery check";
    timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";
      Unit = "battery-monitor.service";
    };
  };
}
