#!/bin/sh
set -e

# 作業用のマウントポイント作成
mkdir -p /mnt-root
# ls -l で確認した正確なラベル名を使用
mount /dev/disk/by-partlabel/disk-main-root /mnt-root

# 1. 現在の @root を old_roots へ退避
if [ -e /mnt-root/@root ]; then
    mkdir -p /mnt-root/old_roots
    timestamp=$(date "+%Y-%m-%d_%H%M%S")
    # サブボリュームを移動（これ自体は一瞬で終わります）
    mv /mnt-root/@root "/mnt-root/old_roots/$timestamp"
fi

# 2. 古いスナップショットの掃除（80%以上なら最古を削除）
usage=$(df /mnt-root | tail -n1 | awk '{print $5}' | sed 's/%//')
if [ "$usage" -gt 80 ]; then
    echo "Disk usage high ($usage%), cleaning up old roots..."
    # 最古のフォルダを取得して削除
    oldest=$(ls -1 /mnt-root/old_roots | head -n 1)
    if [ -n "$oldest" ]; then
        # 内部にサブボリュームがない前提で削除
        btrfs subvolume delete "/mnt-root/old_roots/$oldest"
    fi
fi

# 3. 新しい空の @root を作成
# NixOSは起動中に /nix から /etc や /var を再生成するので、空でOK
btrfs subvolume create /mnt-root/@root

umount /mnt-root
