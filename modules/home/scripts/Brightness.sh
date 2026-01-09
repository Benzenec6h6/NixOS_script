#!/usr/bin/env bash

# 設定
STEP_NORMAL=5
STEP_FINE=1
ICON="display-brightness-high-symbolic"

# 輝度取得
get_brightness() {
    # brightnessctl の -m 出力は [device, class, current, percent, max]
    brightnessctl -m | cut -d, -f4 | tr -d '%'
}

# 通知送信
send_notification() {
    local brightness
    brightness=$(get_brightness)
    notify-send \
        -a "System" \
        -t 1000 \
        -r 999 \
        --icon="$ICON" \
        -h "int:value:${brightness}" \
        -h string:x-canonical-private-synchronous:brightness_notif \
        -u low \
        "Brightness" "${brightness}%"
}

# 輝度変更
change_brightness() {
    local step=$1
    local op=$2 # "+" または "-"

    # --min-value=1 を指定することで、完全に消灯するのを防ぐ
    if [ "$op" == "-" ]; then
        brightnessctl set "${step}%-" --min-value=1
    else
        brightnessctl set "${step}%+"
    fi

    send_notification
}

case "${1:-}" in
    --inc) change_brightness "$STEP_NORMAL" "+" ;;
    --dec) change_brightness "$STEP_NORMAL" "-" ;;
    --inc-fine) change_brightness "$STEP_FINE" "+" ;;
    --dec-fine) change_brightness "$STEP_FINE" "-" ;;
    --get) get_brightness ;;
    *)
        echo "Usage: $0 [--inc|--dec|--inc-fine|--dec-fine|--get]"
        exit 1
        ;;
esac