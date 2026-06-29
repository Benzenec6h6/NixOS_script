#!/bin/sh
set -e
mkdir -p /mnt-root
mount /dev/mapper/crypted /mnt-root

# 公式ドキュメントの知恵：子サブボリュームを末端から順番に消していく安全な関数
delete_subvolume_recursively() {
    IFS=$'\n'
    # 指定されたパス（@root_old）配下にあるサブボリュームをリストアップして再帰呼び出し
    for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/mnt-root/$i"
    done
    # 末端がすべて消えたら、最後に自分自身（@root_old）を削除
    btrfs subvolume delete "$1"
}

# 1. 既存の @root を @root_old にリネームして退避（これ自体は一瞬で終わります）
if [ -e /mnt-root/@root ]; then
    mv /mnt-root/@root /mnt-root/@root_old
fi

# 2. 読み取り専用の pristine（初期状態）から、今回の起動で使う新しい @root を作成
btrfs subvolume snapshot /mnt-root/@root_pristine /mnt-root/@root

# 3. 【ここがカスタム】溜め込まず、先ほど退避させた @root_old をその場で安全に完全消去
if [ -e /mnt-root/@root_old ]; then
    delete_subvolume_recursively /mnt-root/@root_old
fi

umount /mnt-root
