#!/usr/bin/env bash
set -euo pipefail

# パスをフルパスで指定、または flake の場所へ
cd /etc/nixos/NixOS_script

echo "=== system rebuild ==="
OLD_SYSTEM=$(readlink -f /run/current-system)
OLD_KERNEL=$(uname -a) # kernelバージョンはuname全体で見るのが確実

# 再構築の実行
nixos-rebuild switch --flake .

NEW_SYSTEM=$(readlink -f /run/current-system)
NEW_KERNEL=$(uname -a)

# 簡易的な systemd 比較（パスの比較）
OLD_SYSTEMD=$(readlink -f /run/current-system/sw/bin/systemctl)
NEW_SYSTEMD=$(readlink -f /run/current-system/sw/bin/systemctl)

REBOOT_REQUIRED=0
REASONS=()

if [[ "$OLD_SYSTEM" != "$NEW_SYSTEM" ]]; then
  REBOOT_REQUIRED=1
  REASONS+=("System generation changed")
fi
if [[ "$OLD_KERNEL" != "$NEW_KERNEL" ]]; then
  REBOOT_REQUIRED=1
  REASONS+=("Kernel updated")
fi
if [[ "$OLD_SYSTEMD" != "$NEW_SYSTEMD" ]]; then
  REBOOT_REQUIRED=1
  REASONS+=("Systemd updated")
fi

# メッセージ作成
if [[ "$REBOOT_REQUIRED" -eq 1 ]]; then
  MSG="Reboot recommended: ${REASONS[*]}"
  LEVEL="critical"
else
  MSG="Success! No reboot required."
  LEVEL="normal"
fi

# 全ユーザーのデスクトップに通知を送る（壁）
# 最も簡単な回避策は wall コマンドか、ユーザーを狙い撃ちした通知
wall "$MSG"