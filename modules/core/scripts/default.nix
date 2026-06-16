{pkgs, ...}: {
  imports = [
    ./storage-monitor.nix
    #./wifi-portal-manager.nix
  ];
  environment.systemPackages = [
    (pkgs.callPackage ./hibernate-dynamic.nix {})
    (pkgs.callPackage ./resume-dynamic.nix {})
  ];
}
