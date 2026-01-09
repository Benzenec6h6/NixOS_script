#!/usr/bin/env bash
set -euo pipefail

# デバイス名は環境によって「BAT1」や「ADP1」の場合があるため、存在確認を挟むとより安全です
BATTERY="/sys/class/power_supply/BAT0"
AC="/sys/class/power_supply/AC"

# 存在しない場合は静かに終了
[ -d "$BATTERY" ] || exit 0
[ -d "$AC" ] || exit 0

# XDG_RUNTIME_DIRが取れない場合のフォールバック
STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/battery-monitor"
STATE_FILE="$STATE_DIR/state"

mkdir -p "$STATE_DIR"

capacity=$(cat "$BATTERY/capacity")
ac_online=$(cat "$AC/online")

if [ "$ac_online" -eq 1 ]; then
  CURRENT_STATE="ac"
elif [ "$capacity" -le 20 ]; then
  CURRENT_STATE="low"
else
  CURRENT_STATE="battery"
fi

PREV_STATE=""
[ -f "$STATE_FILE" ] && PREV_STATE="$(cat "$STATE_FILE")"

if [ "$CURRENT_STATE" != "$PREV_STATE" ]; then
  case "$CURRENT_STATE" in
    low)
      notify-send \
        --icon="battery-caution-symbolic" \
        "Battery Low" \
        "Remaining: ${capacity}%"
      ;;
    ac)
      notify-send \
        --icon="battery-full-charged-symbolic" \
        "AC Connected" \
        "Charging / AC online"
      ;;
    battery)
      notify-send \
        --icon="battery-full-symbolic" \
        "Running on Battery" \
        "Remaining: ${capacity}%"
      ;;
  esac
fi

echo "$CURRENT_STATE" > "$STATE_FILE"