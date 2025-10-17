#!/usr/bin/env bash
# 💡 Brightness control script with fine (Shift) adjustment
# Dependencies: brightnessctl, notify-send

# デフォルトの増減ステップ（%）
STEP_NORMAL=5
STEP_FINE=1

# 現在の明るさを整数値で取得
get_brightness() {
    brightnessctl -m | cut -d, -f4 | tr -d '%'
}

# 通知を送る
send_notification() {
    local brightness=$1
    notify-send -e \
        -h string:x-canonical-private-synchronous:brightness_notif \
        -h int:value:"$brightness" \
        -u low \
        "Brightness: ${brightness}%"
}

# 明るさを変更して通知
change_brightness() {
    local delta=$1
    local current new

    current=$(get_brightness)
    new=$((current + delta))

    # 0〜100の範囲に制限
    (( new < 0 )) && new=0
    (( new > 100 )) && new=100

    brightnessctl set "${new}%"
    send_notification "$new"
}

# メイン処理
case "$1" in
    "--get")
        get_brightness
        ;;
    "--inc")
        change_brightness "$STEP_NORMAL"
        ;;
    "--dec")
        change_brightness "-$STEP_NORMAL"
        ;;
    "--inc-fine")
        change_brightness "$STEP_FINE"
        ;;
    "--dec-fine")
        change_brightness "-$STEP_FINE"
        ;;
    *)
        echo "Usage: $0 [--inc|--dec|--inc-fine|--dec-fine|--get]"
        ;;
esac
