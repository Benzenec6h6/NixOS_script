# vhdx-mount.nix
{ config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "nbd" ];
  boot.extraModprobeConfig = "options nbd max_part=8";

  environment.systemPackages = [ pkgs.qemu-utils ];

  # ホストとなるNTFSパーティション
  fileSystems."/mnt/vhd-host" = {
    device = "/dev/disk/by-uuid/3AEEA4D0EEA4862B";
    fsType = "ntfs3";
    options = [ "nofail" "rw" "uid=1000" "gid=100" ];
  };

  systemd.services.mount-vhdx = {
    description = "Mount Windows VHDX via NBD";
    after = [ "mnt-vhd\\x2dhost.mount" ];
    requires = [ "mnt-vhd\\x2dhost.mount" ];
    # wantedBy を外しておくと、起動時に勝手にマウントされず、
    # 必要な時だけ systemctl start する運用も選べます。
    # 常にマウントしておきたい場合はそのままでOKです。
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mount-vhdx-script" ''
        # NBDが使用中の場合は一旦切断
        ${pkgs.qemu-utils}/bin/qemu-nbd -d /dev/nbd0 || true
        # VHDXを接続
        ${pkgs.qemu-utils}/bin/qemu-nbd -c /dev/nbd0 "/mnt/vhd-host/win.vhdx"
        sleep 2
        mkdir -p /mnt/vhd-data
        # Windowsのパーティション(nbd0p1)をマウント
        ${pkgs.util-linux}/bin/mount /dev/nbd0p1 /mnt/vhd-data -o uid=1000,gid=100
      '';
      ExecStop = pkgs.writeShellScript "unmount-vhdx-script" ''
        ${pkgs.util-linux}/bin/umount /mnt/vhd-data || true
        ${pkgs.qemu-utils}/bin/qemu-nbd -d /dev/nbd0 || true
      '';
    };
  };
}
