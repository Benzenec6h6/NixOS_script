{ config, pkgs, lib, ... }:

let
  # portal.sh を Nix に取り込む
  portalMonitor = pkgs.writeShellScriptBin "portal-monitor" ''
    ${builtins.readFile ./portal.sh}
  '';
in
{
  systemd.services.portal-monitor = {
    description = "Captive portal detector";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${portalMonitor}/bin/portal-monitor";
    };
  };

  systemd.timers.portal-monitor = {
    enable = true;
    description = "Periodic captive portal check";
    timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "15s";
      Unit = "portal-monitor.service";
    };
  };
}
