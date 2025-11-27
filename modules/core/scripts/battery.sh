#!/usr/bin/env bash
set -euo pipefail

BATTERY="/sys/class/power_supply/BAT0"
AC="/sys/class/power_supply/AC"

capacity=$(cat "$BATTERY/capacity")
ac_online=$(cat "$AC/online")

ICON_DIR="/run/current-system/sw/share/icons/Papirus-Dark/24x24/symbolic/status"

# Low battery
if [ "$capacity" -le 20 ] && [ "$ac_online" -eq 0 ]; then
    notify-send \
        --icon="$ICON_DIR/battery-caution-symbolic.svg" \
        "Battery Low" \
        "Remaining: ${capacity}%"
    exit 0
fi

# AC connected
if [ "$ac_online" -eq 1 ]; then
    notify-send \
        --icon="$ICON_DIR/battery-full-charged-symbolic.svg" \
        "AC Connected" \
        "Charging / AC online"
    exit 0
fi

# Battery mode
if [ "$ac_online" -eq 0 ]; then
    notify-send \
        --icon="$ICON_DIR/battery-full-symbolic.svg" \
        "Running on Battery" \
        "Remaining: ${capacity}%"
    exit 0
fi
