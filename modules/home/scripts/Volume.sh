#!/usr/bin/env bash
# volume.sh – swaync + Papirusアイコン + pamixer の統合音量制御

ICON_DIR="/run/current-system/sw/share/icons/Papirus-Dark/24x24/symbolic/status"

STEP_NORMAL=5
STEP_FINE=1

# ヘッドホンの接続判定 (WirePlumber / PipeWire)
is_headphones_connected() {
    wpctl status | grep -q "Headphones" && return 0
    return 1
}

# --- Volume helpers ---------------------------------------------------------

get_volume() {
    pamixer --get-volume
}

is_muted() {
    [ "$(pamixer --get-mute)" = "true" ]
}

# --- Icon selection ---------------------------------------------------------

get_volume_icon() {
    if is_muted; then
        if is_headphones_connected; then
            echo "$ICON_DIR/audio-volume-muted-headphones-symbolic.svg"
        else
            echo "$ICON_DIR/audio-volume-muted-symbolic.svg"
        fi
        return
    fi

    if is_headphones_connected; then
        echo "$ICON_DIR/audio-volume-headphones-symbolic.svg"
    else
        echo "$ICON_DIR/audio-volume-high-symbolic.svg"
    fi
}

# --- Notification -----------------------------------------------------------

notify_volume() {
    local vol=$(get_volume)
    local icon=$(get_volume_icon)

    if is_muted; then
        notify-send -e \
            -h string:x-canonical-private-synchronous:volume_notif \
            -h int:value:"0" \
            -u low \
            --icon="$icon" \
            "Volume: Muted"
    else
        notify-send -e \
            -h string:x-canonical-private-synchronous:volume_notif \
            -h int:value:"$vol" \
            -u low \
            --icon="$icon" \
            "Volume: ${vol}%"
    fi
}

# --- Volume adjust ----------------------------------------------------------

change_volume() {
    local delta=$1

    if is_muted; then
        pamixer -u
    fi

    if [[ $delta -gt 0 ]]; then
        pamixer -i "$delta"
    else
        pamixer -d $(( -delta ))
    fi

    notify_volume
}

toggle_volume_mute() {
    if is_muted; then
        pamixer -u
    else
        pamixer -m
    fi
    notify_volume
}

# --- Microphone -------------------------------------------------------------

mic_is_muted() {
    [ "$(pamixer --default-source --get-mute)" = "true" ]
}

mic_get_volume() {
    pamixer --default-source --get-volume
}

mic_get_icon() {
    if mic_is_muted; then
        echo "$ICON_DIR/audio-input-microphone-muted-symbolic.svg"
    else
        echo "$ICON_DIR/audio-input-microphone-high-symbolic.svg"
    fi
}

notify_mic() {
    local vol=$(mic_get_volume)
    local icon=$(mic_get_icon)

    if mic_is_muted; then
        notify-send -e \
            -h string:x-canonical-private-synchronous:mic_notif \
            -h int:value:"0" \
            -u low \
            --icon="$icon" \
            "Microphone: Muted"
    else
        notify-send -e \
            -h string:x-canonical-private-synchronous:mic_notif \
            -h int:value:"$vol" \
            -u low \
            --icon="$icon" \
            "Microphone: ${vol}%"
    fi
}

change_mic_volume() {
    local delta=$1

    if mic_is_muted; then
        pamixer --default-source -u
    fi

    if [[ $delta -gt 0 ]]; then
        pamixer --default-source -i "$delta"
    else
        pamixer --default-source -d $(( -delta ))
    fi

    notify_mic
}

toggle_mic_mute() {
    if mic_is_muted; then
        pamixer --default-source -u
    else
        pamixer --default-source -m
    fi
    notify_mic
}

# --- Dispatcher -------------------------------------------------------------

case "$1" in
    --inc)
        change_volume $STEP_NORMAL ;;
    --dec)
        change_volume -$STEP_NORMAL ;;
    --inc-fine)
        change_volume $STEP_FINE ;;
    --dec-fine)
        change_volume -$STEP_FINE ;;
    --toggle)
        toggle_volume_mute ;;
    --mic-inc)
        change_mic_volume $STEP_NORMAL ;;
    --mic-dec)
        change_mic_volume -$STEP_NORMAL ;;
    --mic-inc-fine)
        change_mic_volume $STEP_FINE ;;
    --mic-dec-fine)
        change_mic_volume -$STEP_FINE ;;
    --toggle-mic)
        toggle_mic_mute ;;
    --get)
        get_volume ;;
    --get-mic)
        mic_get_volume ;;
    *)
        echo "Usage:
  --inc / --dec
  --inc-fine / --dec-fine
  --toggle
  --mic-inc / --mic-dec
  --mic-inc-fine / --mic-dec-fine
  --toggle-mic
  --get / --get-mic"
        ;;
esac
