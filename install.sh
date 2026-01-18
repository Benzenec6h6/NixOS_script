#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
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

# --- パスワード入力 ---
echo "=== Enter password ==="
read -rsp "Password: " PASSWORD
echo
read -rsp "Confirm Password: " PASSWORD2
echo

if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
  echo "Error: passwords do not match"
  exit 1
fi

HASH=$(mkpasswd -m yescrypt "$PASSWORD")
echo "Generated hashed password."

# --- 4. BusIDの自動取得 (pciutilsのlspciを使用) ---
INTEL_BUS=""
NVIDIA_BUS=""
to_nix_busid() {
  local id="$1"
  IFS=':.' read -r bus slot func <<< "$id"
  printf "PCI:%d:%d:%d" "$((16#$bus))" "$((16#$slot))" "$func"
}
if [[ "$HOST" == "laptop" ]]; then
  I_ID=$(lspci | grep -i 'VGA.*Intel' | awk '{print $1}' || true)
  N_ID=$(lspci | grep -i '3D\|VGA.*NVIDIA' | awk '{print $1}' || true)
  [[ -n "$I_ID" ]] && INTEL_BUS=$(to_nix_busid "$I_ID")
  [[ -n "$N_ID" ]] && NVIDIA_BUS=$(to_nix_busid "$N_ID")
else
  mkdir -p /tmp/host_share
  mount -t 9p -o trans=virtio shared_vars /tmp/host_share
  cp /tmp/host_share/vars.nix NixOS_script/vars.nix
fi

# --- パーティション作成・フォーマット ---
echo "WARNING: All existing data will be erased! Continue? (y/n)"
read -rp "Confirm: " CONFIRM

case "$CONFIRM" in
  y|Y) echo "Proceeding..." ;;
  n|N) echo "Aborted."; exit 1 ;;
  *) echo "Invalid input"; exit 1 ;;
esac

# --- 共有フォルダ等からコピー済みの vars.nix がある前提 ---
VARS_FILE="$SCRIPT_DIR/vars.nix"

if [[ ! -f "$VARS_FILE" ]]; then
  echo "Error: $VARS_FILE not found. Please copy it from shared folder first."
  exit 1
fi

echo "=== Patching vars.nix with collected info ==="

sed -i "s|host = \"HOST\";|host = \"$HOST\";|" "$VARS_FILE"
sed -i "s|disk = \"DISK\";|disk = \"$DISK\";|" "$VARS_FILE"

# ユーザー名とパスワードハッシュの置換
sed -i "s|password = \"HASH\";|password = \"$HASH\";|" "$VARS_FILE"

# BusIDの置換（vars.nix側もこれに合わせてキーワードにすると確実です）
sed -i "s|intel = \"INTEL_BUS\";|intel = \"$INTEL_BUS\";|" "$VARS_FILE"
sed -i "s|nvidia = \"NVIDIA_BUS\";|nvidia = \"$NVIDIA_BUS\";|" "$VARS_FILE"

echo "Done. vars.nix has been updated."

# --- Diskoの実行 ---
echo "=== Running Disko ==="
disko --mode disko --flake "$SCRIPT_DIR#$HOST" --argstr device "$DISK"

# hardware-configuration.nix生成
nixos-generate-config --root /mnt

# --- NixOS インストール ---
echo "=== Installing NixOS ==="
cp -r "$SCRIPT_DIR" /mnt/etc/nixos/NixOS_script

cp /mnt/etc/nixos/hardware-configuration.nix \
    /mnt/etc/nixos/NixOS_script/hosts/${HOST}/hardware.nix

nixos-install --flake /mnt/etc/nixos/NixOS_script#"$HOST" --no-root-passwd

echo "=== Installation complete! ==="
echo "Target disk: $DISK"
echo "Host: $HOST"
echo "User: $USERNAME"
