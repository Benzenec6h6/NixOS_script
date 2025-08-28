#!/usr/bin/env bash
set -euo pipefail

# --- 1. 初期設定 ---
USERNAME="${USERNAME:-teto}"  # 環境変数で指定可能、デフォルト alice
DISK=""

# --- 2. ディスク選択 ---
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')
if ((${#disks[@]}==0)); then echo "No block device found"; exit 1; fi

echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1)) "$(awk '{print $1}' <<<"${disks[$i]}")" "$(awk '{print $2}' <<<"${disks[$i]}")"
done

read -rp 'Index: ' idx
((idx>=1 && idx<=${#disks[@]})) || { echo "Invalid index"; exit 1; }
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"
echo "→ selected $DISK"

# --- 3. パーティション作成 ---
parted $DISK -- mklabel gpt
parted $DISK -- mkpart primary 1MiB 512MiB
parted $DISK -- mkpart primary 512MiB 100%
parted $DISK -- set 1 esp on

# --- 4. フォーマット ---
mkfs.fat -F 32 ${DISK}1
mkfs.ext4 -F ${DISK}2

# --- 5. マウント ---
mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

# --- 6. ハードウェア設定生成 ---
nixos-generate-config --root /mnt

# --- 7. Flake クローン ---
git clone https://github.com/JaKooLit/NixOS-Hyprland.git /mnt/etc/nixos/NixOS-Hyprland
cd /mnt/etc/nixos/NixOS-Hyprland

# --- 8. インストール ---
# Flake 内の nixosConfigurations 名は NixOS-Hyprland
sudo nixos-install --flake .#NixOS-Hyprland --extra-flake-args "username=$USERNAME"

echo "== Install complete! =="
echo "Reboot and login with user: $USERNAME"
