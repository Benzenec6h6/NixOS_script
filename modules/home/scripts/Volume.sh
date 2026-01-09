#!/usr/bin/env bash

STEP_NORMAL=5
STEP_FINE=1

# カード番号に依存せず、名前でヘッドホン状態を判定する
is_headphones_connected() {
    # 'Headphone' という名前を含むコントロールの値をチェック
    # カード番号を指定せず、全てのオーディオデバイスから検索
    amixer contents 2>/dev/null | grep -A 2 "Headphone" | grep -q "values=on"
}

# --- Volume helpers ---
get_volume() { pamixer --get-volume; }
is_muted() { [ "$(pamixer --get-mute)" = "true" ]; }

# --- Icon selection ---
get_volume_icon() {
    if is_muted; then
        is_headphones_connected && echo "audio-volume-muted-headphones-symbolic" || echo "audio-volume-muted-symbolic"
    else
        is_headphones_connected && echo "audio-volume-headphones-symbolic" || echo "audio-volume-high-symbolic"
    fi
}

# --- Notification ---
notify_volume() {
    local vol
    vol=$(get_volume)
    local icon
    icon=$(get_volume_icon)
    local label="Volume"
    
    [ "$vol" -eq 0 ] || is_muted && label="Volume: Muted" || label="Volume: ${vol}%"

    notify-send -e \
        -a "System" \
        -r 998 \
        -h string:x-canonical-private-synchronous:volume_notif \
        -h "int:value:${vol}" \
        -u low \
        --icon="$icon" \
        "$label"
}

# --- Volume adjust ---
change_volume() {
    local delta=$1
    if is_muted; then pamixer -u; fi

    if [[ $delta -gt 0 ]]; then
        pamixer -i "$delta" --allow-boost # 100%以上を許可する場合はこれ
    else
        pamixer -d "${delta#-}" # 負の記号を除去
    fi
    notify_volume
}

# --- Microphone helpers ---
mic_is_muted() { [ "$(pamixer --default-source --get-mute)" = "true" ]; }
mic_get_volume() { pamixer --default-source --get-volume; }

notify_mic() {
    local vol
    vol=$(mic_get_volume)
    local label="Microphone: ${vol}%"
    mic_is_muted && label="Microphone: Muted"

    notify-send -e \
        -a "System" \
        -r 997 \
        -h string:x-canonical-private-synchronous:mic_notif \
        -h "int:value:${vol}" \
        -u low \
        --icon="$(mic_is_muted && echo "audio-input-microphone-muted-symbolic" || echo "audio-input-microphone-high-symbolic")" \
        "$label"
}

# (中略: micのロジックは基本同様に整理)
# case文での呼び出しも同様