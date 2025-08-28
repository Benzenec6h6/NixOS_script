#!/usr/bin/env bash
set -euo pipefail
#set -eux

mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')

if ((${#disks[@]}==0)); then
  echo "No block device found"; exit 1
fi

echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1))  \
    "$(awk '{print $1}' <<<"${disks[$i]}")" \
    "$(awk '{print $2}' <<<"${disks[$i]}")"
done

read -rp 'Index: ' idx
((idx>=1 && idx<=${#disks[@]})) || { echo "Invalid index"; exit 1; }
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"
echo "→ selected $DISK"

# 1. パーティション作成
parted $DISK -- mklabel gpt
parted $DISK -- mkpart primary 1MiB 512MiB
parted $DISK -- mkpart primary 512MiB 100%
parted $DISK -- set 1 esp on

# 2. フォーマット
mkfs.fat -F 32 ${DISK}1
mkfs.ext4 -F ${DISK}2

# 3. マウント
mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

# 4. 設定ファイル生成
nixos-generate-config --root /mnt

# 5. コピー
cp ./configuration.nix /mnt/etc/nixos/configuration.nix

# 6. インストール
nixos-install --no-root-passwd