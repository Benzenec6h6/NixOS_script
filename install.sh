#!/usr/bin/env bash
set -euo pipefail

# === 設定：wifi.sh が作ったリンクを参照する ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_PATH="$SCRIPT_DIR/backup_src"

if [ ! -d "$BACKUP_PATH" ]; then
    echo "Error: Backup source link not found."
    echo "Please run wifi.sh first or create a link at $BACKUP_PATH"
    exit 1
fi

# === 1. 情報収集 ===
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')
echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1)) "$(awk '{print $1}' <<<"${disks[$i]}")" "$(awk '{print $2}' <<<"${disks[$i]}")"
done
read -rp 'Index: ' idx
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"

echo "=== Select host (1:laptop, 2:vm) ==="
read -rp "Index: " HOST_ID
[[ "$HOST_ID" == "1" ]] && HOST="laptop" || HOST="vm"

# === 2. vars.nix の生成 ===
echo "=== Generating vars.nix from template ==="
cp "$SCRIPT_DIR/vars.nix.template" "$SCRIPT_DIR/vars.nix"
sed -i "s|HOST|$HOST|g" "$SCRIPT_DIR/vars.nix"
sed -i "s|DISK|$DISK|g" "$SCRIPT_DIR/vars.nix"

# GPU BusID 取得
INTEL_BUS=""
NVIDIA_BUS=""
if [[ "$HOST" == "laptop" ]]; then
    to_nix_busid() {
        local id="$1"
        IFS=':.' read -r bus slot func <<< "$id"
        printf "PCI:%d:%d:%d" "$((16#$bus))" "$((16#$slot))" "$func"
    }
    I_ID=$(lspci | grep -i 'VGA.*Intel' | awk '{print $1}' || true)
    N_ID=$(lspci | grep -i '3D\|VGA.*NVIDIA' | awk '{print $1}' || true)
    [[ -n "$I_ID" ]] && INTEL_BUS=$(to_nix_busid "$I_ID")
    [[ -n "$N_ID" ]] && NVIDIA_BUS=$(to_nix_busid "$N_ID")
fi
sed -i "s|INTEL_BUS|$INTEL_BUS|g" "$SCRIPT_DIR/vars.nix"
sed -i "s|NVIDIA_BUS|$NVIDIA_BUS|g" "$SCRIPT_DIR/vars.nix"

# === 3. Disko実行 (ディスク暗号化・マウント) ===
echo "=== Running Disko (Enter LUKS password) ==="
sudo nix run github:nix-community/disko -- --mode zap_create_mount --flake "$SCRIPT_DIR#$HOST"

# === 4. 鍵の復元 (sops-nix / sbctl) ===
echo "=== Restoring identity keys ==="

# SSHホスト鍵の復元 (sops-nixがOSパスワードを復号するために不可欠)
# disko.nix の @persist を /mnt/persist にマウントしている前提
TARGET_SSH="/mnt/persist/etc/ssh"
sudo mkdir -p "$TARGET_SSH"
sudo cp -r "$BACKUP_PATH/ssh" "$TARGET_SSH/"
sudo chown -R root:root "$TARGET_SSH"
sudo find "$TARGET_SSH" -type d -exec chmod 755 {} +
sudo find "$TARGET_SSH" -type f -exec chmod 600 {} +
# 公開鍵（.pub）だけは 644（誰でも読める）にしておくのが標準的
sudo find "$TARGET_SSH" -name "*.pub" -exec chmod 644 {} +

# sbctl (セキュアブート)
sudo mkdir -p /mnt/var/lib/sbctl
sudo cp -r "$BACKUP_PATH/sbctl/"* /mnt/var/lib/sbctl/

# age keys.txt (ユーザーの編集用)
TARGET_AGE="/mnt/home/teto/.config/sops/age"
sudo mkdir -p "$TARGET_AGE"
sudo cp "$BACKUP_PATH/keys.txt" "$TARGET_AGE/"
sudo chown -R 1000:100 "/mnt/home/teto/.config"

# === 5. hardware.nix の生成と微調整 ===
echo "=== Patching hardware.nix ==="
sudo nixos-generate-config --no-filesystems --root /mnt
#sudo nixos-generate-config --root /mnt
sudo sed -i '/^[[:space:]]*fileSystems\./,/^[[:space:]]*};/d' /mnt/etc/nixos/hardware-configuration.nix
sudo sed -i '/^[[:space:]]*swapDevices[[:space:]]*=/d' /mnt/etc/nixos/hardware-configuration.nix
sudo sed -i '/boot.initrd.luks.devices/,/};/d' /mnt/etc/nixos/hardware-configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix "$SCRIPT_DIR/hosts/${HOST}/hardware.nix"

# === 6. NixOS インストール ===
echo "=== Starting NixOS Installation ==="
nixos-install --flake "$SCRIPT_DIR#$HOST"

echo "Installation complete. Reboot now."
