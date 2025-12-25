{ config, pkgs, lib, ... }:

let
  updateRebuild = pkgs.writeShellScriptBin "update-rebuild" ''
    ${builtins.readFile ./update_rebuild.sh}
  '';
in
{
  systemd.services.update-rebuild = {
    description = "Weekly NixOS rebuild";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${updateRebuild}/bin/update-rebuild";
    };
  };

  systemd.timers.update-rebuild = {
    enable = true;
    description = "Weekly NixOS rebuild timer";
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "30m";
      Unit = "update-rebuild.service";
    };
  };
}
