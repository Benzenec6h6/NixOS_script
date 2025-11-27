{ config, pkgs, lib, ... }:

let
  # battery.sh を Nix に取り込む
  batteryMonitor = pkgs.writeShellScriptBin "battery-monitor" ''
    ${builtins.readFile ./battery.sh}
  '';
in
{
  systemd.services.battery-monitor = {
    description = "Battery monitor notifications";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${batteryMonitor}/bin/battery-monitor";
    };
  };

  systemd.timers.battery-monitor = {
    enable = true;
    description = "Periodic battery check";
    timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";
      Unit = "battery-monitor.service";
    };
  };
}
