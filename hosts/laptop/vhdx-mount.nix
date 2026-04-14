{ config, pkgs, ... }:
{
  boot.supportedFilesystems = [ "ntfs" "ntfs3" ];
  boot.kernelModules = [ "nbd" ];
  boot.kernelParams = [ "nbd.max_part=8" ];

  # ホストのNTFSマウント
  fileSystems."/mnt/vhd-host" = {
    device = "/dev/disk/by-uuid/0C021AFE021AEC88";
    fsType = "ntfs3"; # もしエラーが続くなら "ntfs-3g" に変更
    options = [ "nofail" "rw" "uid=1000" "gid=100" "force" ];
  };

  systemd.services.mount-vhdx = {
    description = "Mount Windows VHDX via NBD";
    
    # マウント後に実行するが、マウントが失敗してもサービス自体は死なないようにする
    after = [ "mnt-vhd-host.mount" "local-fs.target" ];
    wants = [ "mnt-vhd-host.mount" ];
    
    # /mnt/vhd-host がマウントされている時だけ実行する条件
    unitConfig.ConditionPathIsMountPoint = "/mnt/vhd-host";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mount-vhdx-script" ''
        set -e
        # NBDが使用中の場合は一旦切断
        ${pkgs.qemu-utils}/bin/qemu-nbd -d /dev/nbd0 || true
        
        # VHDXを接続
        echo "Connecting VHDX..."
        ${pkgs.qemu-utils}/bin/qemu-nbd -c /dev/nbd0 "/mnt/vhd-host/win.vhdx" -f vhdx
        
        # パーティションが認識されるまで少し待機
        sleep 3
        
        # パーティション情報の強制リロード
        ${pkgs.util-linux}/bin/partx -u /dev/nbd0 || true
        
        mkdir -p /mnt/vhd-data
        
        # マウント実行（ユーザーの環境に合わせて nbd0p1 を指定）
        # もし複数のパーティションがある場合は /dev/nbd0p3 などの可能性があります
        echo "Mounting /dev/nbd0p1..."
        ${pkgs.util-linux}/bin/mount /dev/nbd0p1 /mnt/vhd-data -o uid=1000,gid=100,nofail
      '';
      ExecStop = pkgs.writeShellScript "unmount-vhdx-script" ''
        ${pkgs.util-linux}/bin/umount /mnt/vhd-data || true
        ${pkgs.qemu-utils}/bin/qemu-nbd -d /dev/nbd0 || true
      '';
    };
  };
}
