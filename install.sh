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

if [[ "$DISK" == *"nvme"* ]]; then
  PART_SUFFIX="p"
else
  PART_SUFFIX=""
fi

# --- ホスト選択（数字入力に変更） ---
echo "=== Select host ==="
echo "1) laptop"
echo "2) vm"
read -rp "Enter number (1 or 2): " HOST_ID

case "$HOST_ID" in
  1) HOST="laptop" ;;
  2) HOST="vm" ;;
  *) echo "Error: invalid host selection"; exit 1 ;;
esac

echo "Selected host: $HOST"
export HOST="$HOST"

# --- ユーザー名入力 ---
echo "=== Enter username to create ==="
read -rp "Username: " USERNAME

if [[ -z "$USERNAME" ]]; then
  echo "Error: username cannot be empty"
  exit 1
fi

echo "Entered username: $USERNAME"

# --- flake.nix の username を置換 ---
if [ -f ./flake.nix ]; then
  echo "Updating ./flake.nix..."
  sed -i "s/username = \".*\";/username = \"$USERNAME\";/" ./flake.nix
else
  echo "Warning: ./flake.nix not found"
fi

# --- パスワード入力 ---
echo "=== Enter password for $USERNAME ==="
read -rsp "Password: " PASSWORD
echo
read -rsp "Confirm Password: " PASSWORD2
echo

if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
  echo "Error: passwords do not match"
  exit 1
fi

HASH=$(mkpasswd -m sha-512 "$PASSWORD")
echo "Generated hashed password."

if [ -f ./flake.nix ]; then
  echo "Updating hashedPassword in flake.nix..."
  sed -i "s|userPassword = \".*\";|userPassword = \"$HASH\";|" ./flake.nix
else
  echo "Warning: flake.nix not found!"
fi

# --- laptop の場合だけ GPU BusID を設定 ---
if [[ "$HOST" == "laptop" ]]; then
  INTEL_ID=$(lspci | grep -i 'VGA.*Intel' | awk '{print $1}' || true)
  NVIDIA_ID=$(lspci | grep -i '3D\|VGA.*NVIDIA' | awk '{print $1}' || true)

  to_nix_busid() {
    local id="$1"
    IFS=':.' read -r bus slot func <<< "$id"
    printf "PCI:%d:%d:%d" "$((16#$bus))" "$((16#$slot))" "$func"
  }

  if [[ -n "$INTEL_ID" ]]; then
    INTEL_BUSID=$(to_nix_busid "$INTEL_ID")
    sed -i "s|intelBusId = \".*\";|intelBusId = \"$INTEL_BUSID\";|" ./hosts/laptop.nix
  fi

  if [[ -n "$NVIDIA_ID" ]]; then
    NVIDIA_BUSID=$(to_nix_busid "$NVIDIA_ID")
    sed -i "s|nvidiaBusId = \".*\";|nvidiaBusId = \"$NVIDIA_BUSID\";|" ./hosts/laptop.nix
  fi
fi

# --- パーティション作成・フォーマット ---
echo "=== Partitioning and formatting disk ($DISK) ==="
echo "WARNING: All existing data will be erased! Continue? (y/n)"
read -rp "Confirm: " CONFIRM

case "$CONFIRM" in
  y|Y) echo "Proceeding..." ;;
  n|N) echo "Aborted."; exit 1 ;;
  *) echo "Invalid input"; exit 1 ;;
esac

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary 512MiB 100%

mkfs.fat -F32 "${DISK}${PART_SUFFIX}1"
mkfs.ext4     "${DISK}${PART_SUFFIX}2"

mount "${DISK}${PART_SUFFIX}2" /mnt
mkdir -p /mnt/boot
mount "${DISK}${PART_SUFFIX}1" /mnt/boot

# hardware-configuration.nix生成
nixos-generate-config --root /mnt

# --- NixOS インストール ---
echo "=== Installing NixOS ==="
cp -r /home/nixos/NixOS_script /mnt/etc/nixos/

cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/etc/nixos/NixOS_script/hosts/hardware.nix

nixos-install --flake /mnt/etc/nixos/NixOS_script#"$HOST" --no-root-passwd

echo "=== Installation complete! ==="
echo "Target disk: $DISK"
echo "Host: $HOST"
echo "User: $USERNAME"
