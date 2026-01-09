{ config, pkgs, ... }:

{
  imports = [
    ./update_rebuild.nix
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./hibernate-dynamic.nix {})
    (pkgs.callPackage ./resume-dynamic.nix {})
  ];
}
