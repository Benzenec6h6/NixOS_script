#!/bin/bash
# 🎧 Simplified Volume Control Script

STEP_NORMAL=5
STEP_FINE=1

get_volume() {
    pamixer --get-volume
}

is_muted() {
    pamixer --get-mute
}

send_notification() {
    local volume=$1
    if [ "$(is_muted)" = "true" ]; then
        notify-send -e -u low "Volume: Muted"
    else
        notify-send -e -u low -h int:value:"$volume" "Volume: ${volume}%"
    fi
}

change_volume() {
    local delta=$1
    if [ "$(is_muted)" = "true" ]; then
        pamixer -u  # 自動でミュート解除
    fi
    pamixer -i "$delta"
    send_notification "$(get_volume)"
}

case "$1" in
    "--get") get_volume ;;
    "--inc") change_volume "$STEP_NORMAL" ;;
    "--dec") change_volume "-$STEP_NORMAL" ;;
    "--inc-fine") change_volume "$STEP_FINE" ;;
    "--dec-fine") change_volume "-$STEP_FINE" ;;
    "--toggle") pamixer -t && send_notification "$(get_volume)" ;;
    *) echo "Usage: $0 [--inc|--dec|--inc-fine|--dec-fine|--toggle|--get]" ;;
esac
