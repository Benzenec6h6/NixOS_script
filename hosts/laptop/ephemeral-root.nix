{pkgs, ...}: {
  boot.initrd.systemd.extraBin = {
    btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
  };

  boot.initrd.systemd.services.rollback = {
    description = "Rollback root subvolume to a blank state";
    wantedBy = ["initrd.target"];
    after = [
      "cryptsetup.target"
      "systemd-cryptsetup@crypted.service"
    ];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = builtins.readFile ./rollback.sh;
  };
}
