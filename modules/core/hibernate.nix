{ config, pkgs, lib, ... }:

let
  resumeDynamic = pkgs.callPackage ./scripts/resume-dynamic.nix {};
in
{
  boot.initrd.systemd.enable = true;

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
}
