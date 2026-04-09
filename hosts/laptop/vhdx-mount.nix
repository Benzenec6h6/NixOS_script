{ config, pkgs, ... }:

{
  # 1. 必要なツールとカーネルモジュールのロード
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "nbd" ];
  boot.extraModprobeConfig = "options nbd max_part=8";

  environment.systemPackages = [ pkgs.qemu-utils ];

  # 2. ホストとなるNTFSパーティションのマウント (nvme0n1p3)
  fileSystems."/mnt/vhd-host" = {
    device = "/dev/disk/by-uuid/3AEEA4D0EEA4862B";
    fsType = "ntfs3";
    options = [ "nofail" "rw" "uid=1000" "gid=100" ];
  };

  # 3. VHDXをnbdデバイスとして接続・マウントするSystemdサービス
  systemd.services.mount-vhdx = {
    description = "Mount VHDX inside NTFS partition";
    after = [ "mnt-vhd-host.mount" ]; # NTFSがマウントされた後に実行
    requires = [ "mnt-vhd-host.mount" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mount-vhdx-script" ''
        # nbdデバイスをファイルに紐付け
        # /mnt/vhd-host/ の後のパスは実際のファイル名に合わせてください
        ${pkgs.qemu-utils}/bin/qemu-nbd -c /dev/nbd0 "/mnt/vhd-host/win.vhdx"
        
        # パーティション認識を待つ
        sleep 2
        
        # マウントポイント作成とマウント (nbd0p1などの番号は中身に合わせる)
        mkdir -p /mnt/vhd-data
        mount /dev/nbd0p1 /mnt/vhd-data -o uid=1000,gid=100
      '';
      ExecStop = pkgs.writeShellScript "unmount-vhdx-script" ''
        umount /mnt/vhd-data
        ${pkgs.qemu-utils}/bin/qemu-nbd -d /dev/nbd0
      '';
    };
  };
}
