#!/bin/sh
set -e
mkdir -p /mnt-root
mount /dev/mapper/crypted /mnt-root

# 子サブボリュームを末端から順番に消していく安全な関数
delete_subvolume_recursively() {
    IFS=$'\n'
    for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/mnt-root/$i"
    done
    btrfs subvolume delete "$1"
}

# 1. 既存の @root を @root_old にリネームして退避
if [ -e /mnt-root/@root ]; then
    mv /mnt-root/@root /mnt-root/@root_old
fi

# 2. 【重要】スナップショットではなく、完全に「空」のサブボリュームを新規作成する
# これにより NixOS は起動時に「現在の世代」に合わせたシンボリックリンクを 
# /nix/store からクリーンに作成します。
btrfs subvolume create /mnt-root/@root

# 3. 退避させた @root_old を削除
if [ -e /mnt-root/@root_old ]; then
    delete_subvolume_recursively /mnt-root/@root_old
fi

umount /mnt-root
