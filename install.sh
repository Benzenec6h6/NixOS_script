#!/usr/bin/env bash
set -euo pipefail

# === ディスク選択 ===
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')

if ((${#disks[@]}==0)); then
  echo "No block device found"; exit 1
fi

echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1)) \
    "$(awk '{print $1}' <<<"${disks[$i]}")" \
    "$(awk '{print $2}' <<<"${disks[$i]}")"
done

read -rp 'Index: ' idx
((idx>=1 && idx<=${#disks[@]})) || { echo "Invalid index"; exit 1; }
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"
echo "→ selected $DISK"

# === パーティション作成 ===
parted $DISK -- mklabel gpt
parted $DISK -- mkpart primary 1MiB 512MiB
parted $DISK -- mkpart primary 512MiB 100%
parted $DISK -- set 1 esp on

# === フォーマット ===
mkfs.fat -F 32 ${DISK}1
mkfs.ext4 -F ${DISK}2

# === マウント ===
mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

# === 設定ファイル生成 ===
nixos-generate-config --root /mnt

# === リポジトリ取得 (自分のforkを指定！) ===
git clone https://github.com/Benzenec6h6/NixOS-Hyprland.git /mnt/etc/nixos/NixOS-Hyprland

# === hardware.nix のコピー ===
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/etc/nixos/NixOS-Hyprland/hosts/default/hardware.nix

# === インストール ===
nixos-install --flake /mnt/etc/nixos/NixOS-Hyprland#NixOS-Hyprland --no-root-passwd
