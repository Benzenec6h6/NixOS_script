#!/usr/bin/env bash
set -euo pipefail

STEP_NORMAL=5
STEP_FINE=1

# -------------------------------------------------------------------
# Headphone detection (card-number independent)
# -------------------------------------------------------------------
is_headphones_connected() {
    amixer contents 2>/dev/null \
        | grep -A 2 -i "headphone" \
        | grep -q "values=on"
}

# -------------------------------------------------------------------
# Volume helpers (sink)
# -------------------------------------------------------------------
get_volume() {
    pamixer --get-volume
}

is_muted() {
    [ "$(pamixer --get-mute)" = "true" ]
}

get_volume_icon() {
    if is_muted; then
        if is_headphones_connected; then
            echo "audio-volume-muted-headphones-symbolic"
        else
            echo "audio-volume-muted-symbolic"
        fi
    else
        if is_headphones_connected; then
            echo "audio-volume-headphones-symbolic"
        else
            echo "audio-volume-high-symbolic"
        fi
    fi
}

notify_volume() {
    local vol icon label
    vol=$(get_volume)
    icon=$(get_volume_icon)

    if is_muted || [ "$vol" -eq 0 ]; then
        label="Volume: Muted"
        vol=0
    else
        label="Volume: ${vol}%"
    fi

    notify-send -e \
        -a "System" \
        -r 998 \
        -h string:x-canonical-private-synchronous:volume_notif \
        -h "int:value:${vol}" \
        -u low \
        --icon="$icon" \
        "$label"
}

change_volume() {
    local delta=$1

    if is_muted; then
        pamixer -u
    fi

    if [ "$delta" -gt 0 ]; then
        pamixer -i "$delta" --allow-boost
    else
        pamixer -d "${delta#-}"
    fi

    notify_volume
}

toggle_volume_mute() {
    pamixer -t
    notify_volume
}

# -------------------------------------------------------------------
# Microphone helpers (source)
# -------------------------------------------------------------------
mic_get_volume() {
    pamixer --default-source --get-volume
}

mic_is_muted() {
    [ "$(pamixer --default-source --get-mute)" = "true" ]
}

mic_get_icon() {
    if mic_is_muted; then
        echo "audio-input-microphone-muted-symbolic"
    else
        echo "audio-input-microphone-high-symbolic"
    fi
}

notify_mic() {
    local vol icon label
    vol=$(mic_get_volume)
    icon=$(mic_get_icon)

    if mic_is_muted || [ "$vol" -eq 0 ]; then
        label="Microphone: Muted"
        vol=0
    else
        label="Microphone: ${vol}%"
    fi

    notify-send -e \
        -a "System" \
        -r 997 \
        -h string:x-canonical-private-synchronous:mic_notif \
        -h "int:value:${vol}" \
        -u low \
        --icon="$icon" \
        "$label"
}

change_mic_volume() {
    local delta=$1

    if mic_is_muted; then
        pamixer --default-source -u
    fi

    if [ "$delta" -gt 0 ]; then
        pamixer --default-source -i "$delta"
    else
        pamixer --default-source -d "${delta#-}"
    fi

    notify_mic
}

toggle_mic_mute() {
    pamixer --default-source -t
    notify_mic
}

# -------------------------------------------------------------------
# Dispatcher
# -------------------------------------------------------------------
case "${1:-}" in
    --inc)            change_volume "$STEP_NORMAL" ;;
    --dec)            change_volume "-$STEP_NORMAL" ;;
    --inc-fine)       change_volume "$STEP_FINE" ;;
    --dec-fine)       change_volume "-$STEP_FINE" ;;
    --toggle)         toggle_volume_mute ;;

    --mic-inc)        change_mic_volume "$STEP_NORMAL" ;;
    --mic-dec)        change_mic_volume "-$STEP_NORMAL" ;;
    --mic-inc-fine)   change_mic_volume "$STEP_FINE" ;;
    --mic-dec-fine)   change_mic_volume "-$STEP_FINE" ;;
    --toggle-mic)     toggle_mic_mute ;;

    --get)            get_volume ;;
    --get-mic)        mic_get_volume ;;
    *)
        cat <<EOF
Usage:
  --inc / --dec
  --inc-fine / --dec-fine
  --toggle
  --mic-inc / --mic-dec
  --mic-inc-fine / --mic-dec-fine
  --toggle-mic
  --get / --get-mic
EOF
        ;;
esac
