#!/usr/bin/env bash
set -euo pipefail

BATTERY="/sys/class/power_supply/BAT0"
AC="/sys/class/power_supply/AC"

capacity=$(cat "$BATTERY/capacity")
ac_online=$(cat "$AC/online")

# Low battery
if [ "$capacity" -le 20 ] && [ "$ac_online" -eq 0 ]; then
    notify-send \
        --icon="battery-caution-symbolic" \
        "Battery Low" \
        "Remaining: ${capacity}%"
    exit 0
fi

# AC connected
if [ "$ac_online" -eq 1 ]; then
    notify-send \
        --icon="battery-full-charged-symbolic" \
        "AC Connected" \
        "Charging / AC online"
    exit 0
fi

# Battery mode
if [ "$ac_online" -eq 0 ]; then
    notify-send \
        --icon="battery-full-symbolic" \
        "Running on Battery" \
        "Remaining: ${capacity}%"
    exit 0
fi
