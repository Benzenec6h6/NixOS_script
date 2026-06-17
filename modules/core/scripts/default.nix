{pkgs, ...}: {
  imports = [
    ./storage-monitor.nix
  ];
  environment.systemPackages = [
    (pkgs.callPackage ./hibernate-dynamic.nix {})
    (pkgs.callPackage ./resume-dynamic.nix {})
  ];
}
