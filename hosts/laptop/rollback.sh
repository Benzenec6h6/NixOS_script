#!/bin/sh
set -e
mkdir -p /mnt-root
mount /dev/mapper/crypted /mnt-root

delete_subvolume_recursively() {
    IFS=$'\n'
    for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/mnt-root/$i"
    done
    btrfs subvolume delete "$1"
}

# --- @root のリセット ---
if [ -e /mnt-root/@root ]; then
    mv /mnt-root/@root /mnt-root/@root_old
fi
btrfs subvolume create /mnt-root/@root

# --- @home のリセット (追加) ---
if [ -e /mnt-root/@home ]; then
    mv /mnt-root/@home /mnt-root/@home_old
fi
btrfs subvolume create /mnt-root/@home

# --- 古いサブボリュームの削除 ---
if [ -e /mnt-root/@root_old ]; then
    delete_subvolume_recursively /mnt-root/@root_old
fi

if [ -e /mnt-root/@home_old ]; then
    delete_subvolume_recursively /mnt-root/@home_old
fi

umount /mnt-root
