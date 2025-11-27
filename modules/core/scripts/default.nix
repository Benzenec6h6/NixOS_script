{ config, pkgs, ... }:

{
  imports = [
    ./battery-monitor.nix
    ./bluetooth_service.nix
    ./network_bluetooth_notify.nix
    ./network_service.nix
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./hibernate-dynamic.nix {})
    (pkgs.callPackage ./resume-dynamic.nix {})
  ];
}
