#!/bin/sh
set -e
mkdir -p /mnt-root
mount /dev/mapper/crypted /mnt-root

# 直前の作業用 @root を削除（pristine ではないので消してOK）
# -R: ネストされたサブボリュームも再帰的に削除する
if btrfs subvolume show /mnt-root/@root >/dev/null 2>&1; then
    btrfs subvolume delete -R /mnt-root/@root
fi

# 読み取り専用の @root_pristine から書き込み可能な @root を作成
btrfs subvolume snapshot /mnt-root/@root_pristine /mnt-root/@root
umount /mnt-root
