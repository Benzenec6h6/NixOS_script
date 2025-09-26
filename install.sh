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

if [[ "$DISK" == nvme* ]]; then
  PART_SUFFIX="p"
else
  PART_SUFFIX=""
fi

# --- ホスト選択 ---
read -rp "ホストを選択してください (laptop/vm): " HOST
if [[ "$HOST" != "laptop" && "$HOST" != "vm" ]]; then
  echo "エラー: laptop か vm を入力してください"
  exit 1
fi

# --- ユーザー名入力 ---
echo "=== 作成するユーザー名を入力してください ==="
read -rp "Username: " USERNAME

if [[ -z "$USERNAME" ]]; then
  echo "エラー: ユーザー名が空です"
  exit 1
fi

echo "入力されたユーザー名: $USERNAME"

# --- flake.nix の username を置換 ---
for flake in system/flake.nix home/flake.nix; do
  if [ -f "$flake" ]; then
    echo "Updating $flake..."
    sed -i "s/username = \".*\";/username = \"$USERNAME\";/" "$flake"
  else
    echo "警告: $flake が見つかりません"
  fi
done

# lspci で GPU の BusID を取得
INTEL_ID=$(lspci | grep -i 'VGA.*Intel'   | awk '{print $1}')
NVIDIA_ID=$(lspci | grep -i '3D\|VGA.*NVIDIA' | awk '{print $1}')

# lspci の出力は 00:02.0 のような形式 → NixOS は PCI:0:2:0 に変換する必要あり
to_nix_busid() {
  local id="$1"
  IFS=':.' read -r bus slot func <<< "$id"
  printf "PCI:%d:%d:%d" "0x$bus" "0x$slot" "0x$func"
}

INTEL_BUSID=$(to_nix_busid "$INTEL_ID")
NVIDIA_BUSID=$(to_nix_busid "$NVIDIA_ID")

echo "Intel BusID:  $INTEL_BUSID"
echo "NVIDIA BusID: $NVIDIA_BUSID"

# laptop.nix を置換
sed -i "s|intelBusId = \".*\";|intelBusId = \"$INTEL_BUSID\";|" ./system/hosts/laptop.nix
sed -i "s|nvidiaBusId = \".*\";|nvidiaBusId = \"$NVIDIA_BUSID\";|" ./system/hosts/laptop.nix

# --- パーティション作成・フォーマット例 ---
echo "=== ディスクをパーティション・フォーマットします (/dev/$DISK) ==="
echo "注意: 既存のデータはすべて消去されます！続行するには yes と入力してください。"
read -rp "Confirm (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "中止しました。"
  exit 1
fi

parted /dev/$DISK -- mklabel gpt
parted /dev/$DISK -- mkpart ESP fat32 1MiB 512MiB
parted /dev/$DISK -- set 1 esp on
parted /dev/$DISK -- mkpart primary 512MiB 100%

mkfs.fat -F32 /dev/${DISK}1
mkfs.ext4 /dev/${DISK}2

mount /dev/${DISK}2 /mnt
mkdir -p /mnt/boot
mount /dev/${DISK}1 /mnt/boot

# --- NixOS インストール ---
echo "=== NixOS をインストールします ==="
nixos-install --flake ./system#$HOST --no-root-passwd

echo "=== インストール完了！ ==="
echo "インストール先: /dev/$DISK"
echo "ホスト: $HOST"
echo "ユーザー: $USERNAME"