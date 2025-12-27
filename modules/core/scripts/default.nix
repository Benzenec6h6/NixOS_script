{ config, pkgs, ... }:

{
  imports = [
    #./bluetooth_service.nix
    ./gc_generation.nix
    ./network_bluetooth_notify.nix
    ./network_service.nix
    ./update_rebuild.nix
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./hibernate-dynamic.nix {})
    (pkgs.callPackage ./resume-dynamic.nix {})
  ];
}
