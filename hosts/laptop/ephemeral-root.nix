{pkgs, ...}: {
  boot.initrd.systemd.extraBin = {
    btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
  };

  /*
  boot.initrd.systemd.services.create-pristine-once = {
    description = "Create pristine @root snapshot if missing";
    wantedBy = ["initrd.target"];
    after = [
      "cryptsetup.target"
      "systemd-cryptsetup@crypted.service"
    ];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    # path は指定しない（デフォルトの /bin:/sbin に mount/umount/coreutils が既にある）
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt-root
      for i in {1..5}; do
        if mount /dev/mapper/crypted /mnt-root; then break; fi
        sleep 1
      done
      if ! btrfs subvolume show /mnt-root/@root_pristine >/dev/null 2>&1; then
        btrfs subvolume snapshot -r /mnt-root/@root /mnt-root/@root_pristine
      fi
      umount /mnt-root
    '';
  };
  */

  boot.initrd.systemd.services.rollback = {
    description = "Rollback root subvolume to pristine state";
    wantedBy = ["initrd.target"];
    after = [
      "cryptsetup.target"
      "systemd-cryptsetup@crypted.service"
      "create-pristine-once.service"
    ];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = builtins.readFile ./rollback.sh;
  };
}
