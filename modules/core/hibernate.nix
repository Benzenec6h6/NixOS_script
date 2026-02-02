{ config, pkgs, lib, ... }:

let
  resumeDynamic = pkgs.callPackage ./scripts/resume-dynamic.nix {};
  hibernateDynamic = pkgs.callPackage ./scripts/hibernate-dynamic.nix {};
in
{
  boot.initrd.systemd.services.resume-file = {
    description = "Dynamic resume from swapfile";
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${resumeDynamic}/bin/resume-dynamic";
    };
  };

  swapDevices = [];

  systemd.services."hibernate-dynamic" = {
    description = "Dynamic Hibernate (swapfile auto-allocate)";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${hibernateDynamic}/bin/hibernate-dynamic";
    };
  };
}
