#!/usr/bin/env bash
set -euo pipefail

# 状態保存先
STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/storage-monitor"
STATE_FILE="$STATE_DIR/devices"

mkdir -p "$STATE_DIR"

# 取り外し可能なブロックデバイスを列挙
# lsblkは systemd/udev と整合性が高く安全
CURRENT_DEVICES="$(
  lsblk -nrpo NAME,RM,TYPE |
    awk '$2 == 1 && $3 == "disk" { print $1 }' |
    sort
)"

PREV_DEVICES=""
[ -f "$STATE_FILE" ] && PREV_DEVICES="$(cat "$STATE_FILE")"

# 差分検出（新規追加分）
NEW_DEVICES="$(comm -13 \
  <(printf "%s\n" "$PREV_DEVICES") \
  <(printf "%s\n" "$CURRENT_DEVICES")
)"

if [ -n "$NEW_DEVICES" ]; then
  while read -r dev; do
    [ -z "$dev" ] && continue

    notify-send \
      --icon="drive-removable-media-symbolic" \
      "Removable Storage Connected" \
      "Device: $dev"
  done <<< "$NEW_DEVICES"
fi

# 状態更新
printf "%s\n" "$CURRENT_DEVICES" > "$STATE_FILE"
