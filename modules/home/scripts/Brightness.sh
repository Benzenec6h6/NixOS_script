#!/usr/bin/env bash

STEP_NORMAL=5
STEP_FINE=1
ICON="display-brightness-high-symbolic"

get_brightness() {
    brightnessctl -m | awk -F',' '{gsub(/%/,"",$4); print $4}'
}

send_notification() {
    local brightness=$1
    notify-send \
        --icon="$ICON" \
        -h string:x-canonical-private-synchronous:brightness_notif \
        -u low \
        "Brightness: ${brightness}%"
}

change_brightness() {
    local step=$1
    local mode=$2

    # brightnessctl 内部stepに任せる
    brightnessctl set "${step}%${mode}" > /dev/null

    sleep 0.05  # 反映待ち（重要）
    send_notification "$(get_brightness)"
}

case "$1" in
    --inc) change_brightness "$STEP_NORMAL" "+" ;;
    --dec) change_brightness "$STEP_NORMAL" "-" ;;
    --inc-fine) change_brightness "$STEP_FINE" "+" ;;
    --dec-fine) change_brightness "$STEP_FINE" "-" ;;
    --get) get_brightness ;;
    *)
        echo "Usage: $0 [--inc|--dec|--inc-fine|--dec-fine|--get]"
        ;;
esac
