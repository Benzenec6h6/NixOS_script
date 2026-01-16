#!/bin/sh

mkdir /btrfs_tmp
  mount /dev/disk/by-partlabel/root /btrfs_tmp # パーティション名は環境に合わせて
  if [ -e /btrfs_tmp/@root ]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@root)" "+%Y-%m-%d_%H:%M:%S")
      mv /btrfs_tmp/@root "/btrfs_tmp/old_roots/$timestamp"
  fi

  delete_old_roots() {
    usage=$(df -h /btrfs_tmp | tail -n1 | awk '{print $5}' | sed 's/%//')
    if [ "$usage" -gt 80 ]; then
        ls -1tr /btrfs_tmp/old_roots | head -n 1 | xargs -I{} btrfs subvolume delete "/btrfs_tmp/old_roots/{}"
    fi
  }

  delete_old_roots
  btrfs subvolume create /btrfs_tmp/@root
  umount /btrfs_tmp