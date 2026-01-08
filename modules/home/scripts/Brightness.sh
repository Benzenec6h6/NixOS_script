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
    local op=$2 # "+" または "-"

    if [ "$op" == "-" ]; then
        # 現在の輝度（raw値）と最大値を取得
        local current=$(brightnessctl get)
        local max=$(brightnessctl max)
        # ステップ分を引いたあとの期待値を計算（1%あたりのraw値を考慮）
        # 1を下回らないように制御
        brightnessctl set "${step}%-"
        local new=$(brightnessctl get)
        if [ "$new" -eq 0 ]; then
            brightnessctl set 1
        fi
    else
        brightnessctl set "${step}%+"
    fi

    sleep 0.05
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