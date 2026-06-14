#!/usr/bin/env bash
set -euo pipefail

# udevルール側の %k から渡されたデバイス名（例: sdb）を受け取る
# もし引数が空なら、udevの環境変数 $KERNEL からフォールバック
DEV_NAME="${1:-${KERNEL:-}}"

if [ -z "$DEV_NAME" ]; then
    echo "Error: No device name provided." >&2
    exit 1
fi

# システム（root）から実行されるため、デスクトップ（ユーザー環境）へ通知を届けるためのおまじない
# ※ 最初の一般ユーザーのUIDを取得して環境変数にセット
USER_ID=$(id -u "$(ls /home | head -n1)")
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

# ユーザー権限に切り替えて、SwayNCへ超軽量に通知！
sudo -u "$(ls /home | head -n1)" notify-send \
  --icon="drive-removable-media-symbolic" \
  "Removable Storage Connected" \
  "Device: /dev/$DEV_NAME"
