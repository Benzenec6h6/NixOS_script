{ pkgs, ... }:

let
  portalMonitor = pkgs.writeShellScriptBin "portal-monitor"
    (builtins.readFile ./portal.sh);
in
{
  home.packages = [ portalMonitor ];

  systemd.user.services.portal-monitor = {
    Unit.Description = "Captive portal detector";
    Service = {
      Type = "oneshot";
      ExecStart = "${portalMonitor}/bin/portal-monitor";
    };
  };

  systemd.user.timers.portal-monitor = {
    Unit.Description = "Captive portal check timer";
    Timer = {
      OnBootSec = "10s";
      OnUnitActiveSec = "15s";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
