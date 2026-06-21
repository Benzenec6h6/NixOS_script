{pkgs, ...}: {
  boot.initrd.systemd.services.rollback = {
    description = "Rollback root subvolume to pristine state";
    wantedBy = ["initrd.target"];
    after = ["cryptsetup.target"];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    path = with pkgs; [btrfs-progs coreutils util-linux];
    serviceConfig.Type = "oneshot";
    script = builtins.readFile ./rollback.sh;
  };

  boot.initrd.systemd.services.create-pristine-once = {
    description = "Create pristine @root snapshot if missing";
    wantedBy = ["initrd.target"];
    after = ["cryptsetup.target"];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    path = with pkgs; [btrfs-progs util-linux];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt-root
      mount /dev/mapper/crypted /mnt-root
      if ! btrfs subvolume show /mnt-root/@root_pristine >/dev/null 2>&1; then
        btrfs subvolume snapshot -r /mnt-root/@root /mnt-root/@root_pristine
      fi
      umount /mnt-root
    '';
  };
}
