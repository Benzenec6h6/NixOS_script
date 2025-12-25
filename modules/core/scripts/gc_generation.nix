{ config, pkgs, lib, ... }:

let
  gcGeneration = pkgs.writeShellScriptBin "gc-generation" ''
    ${builtins.readFile ./gc_generation.sh}
  '';
in
{
  systemd.services.gc-generation = {
    description = "Monthly Nix garbage collection";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${gcGeneration}/bin/gc-generation";
    };
  };

  systemd.timers.gc-generation = {
    enable = true;
    description = "Monthly Nix garbage collection timer";
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
      RandomizedDelaySec = "1h";
      Unit = "gc-generation.service";
    };
  };
}
