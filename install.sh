#!/usr/bin/env bash
set -euo pipefail

# --- 1. ディスク選択 ---
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

# --- 2. パーティション作成 ---
parted $DISK -- mklabel gpt
parted $DISK -- mkpart primary 1MiB 512MiB
parted $DISK -- mkpart primary 512MiB 100%
parted $DISK -- set 1 esp on

# --- 3. フォーマット ---
mkfs.fat -F 32 ${DISK}1
mkfs.ext4 -F ${DISK}2

# --- 4. マウント ---
mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

# --- 5. ハードウェア設定生成 ---
nixos-generate-config --root /mnt

# --- 6. Flake クローン ---
git clone https://github.com/JaKooLit/NixOS-Hyprland.git /mnt/etc/nixos/NixOS-Hyprland
cd /mnt/etc/nixos/NixOS-Hyprland

# --- 7. ホスト設定コピー & ユーザー追加 ---
cd hosts
cp -r default myhost

# myhost/users.nix に最低ユーザーを作る
cat > myhost/users.nix <<'EOF'
{ config, pkgs, ... }:
{
  users.users.teto = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };
}
EOF

# --- 8. インストール ---
sudo nixos-install --flake .#myhost
