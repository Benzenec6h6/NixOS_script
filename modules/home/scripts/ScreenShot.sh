#!/usr/bin/env bash

# タイムスタンプと保存先
time=$(date "+%Y-%m-%d_%H-%M-%S")
# xdg-user-dirが無い場合に備えてフォールバックを設定
dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
file="Screenshot_${time}.png"
path="${dir}/${file}"

# アイコン名の設定 (Papirusテーマ内の名前)
ICON_SHOT="image-x-generic"
ICON_TIMER="alarm-clock"
#ICON_EDIT="swappy"
ICON_ERROR="dialog-error"

# 音声ファイルの定義 (より安全なパス、または依存に含める)
SND_CAPTURE="screen-capture.oga"
SND_ERROR="dialog-error.oga"

playsound() {
    if [[ -f "$1" ]]; then
        pw-play "$1" 2>/dev/null &
    fi
}

show_notify() {
    local p="$1"
    if [[ -e "$p" ]]; then
        playsound "$SND_CAPTURE"
        # 通知にアクションを追加 (Open / Delete)
        resp=$(notify-send -t 8000 \
            -a "Screenshot" \
            -i "$ICON_SHOT" \
            -A open="Open" \
            -A del="Delete" \
            -h string:x-canonical-private-synchronous:shot \
            "Screenshot saved" "$p")
            
        case "$resp" in
            "open") xdg-open "$p" & ;;
            "del")  rm "$p" ;;
        esac
    else
        playsound "$SND_ERROR"
        notify-send -u low -i "$ICON_ERROR" "Screenshot" "Failed to save"
    fi
}

mkdir -p "$dir"

#===== Actions =====#

shot_now() {
    grim "$path"
    wl-copy < "$path"
    show_notify "$path"
}

shot_timer() {
    local sec="$1"
    for s in $(seq "$sec" -1 1); do
        notify-send -t 1000 -i "$ICON_TIMER" "Screenshot in…" "$s seconds" -h string:x-canonical-private-synchronous:timer
        sleep 1
    done
    shot_now
}

shot_area() {
    local area
    area=$(slurp) || exit 0 # キャンセル時は終了
    if grim -g "$area" "$path"; then
        wl-copy < "$path"
        show_notify "$path"
    else
        playsound "$SND_ERROR"
    fi
}

shot_active() {
    local info
    info=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    grim -g "$info" "$path"
    wl-copy < "$path"
    show_notify "$path"
}

shot_swappy() {
    local area
    area=$(slurp) || exit 0
    # 直接 swappy に流し込む
    grim -g "$area" - | swappy -f -
}

case "${1:-}" in
    --now)    shot_now ;;
    --in5)    shot_timer 5 ;;
    --in10)   shot_timer 10 ;;
    --area)   shot_area ;;
    --active) shot_active ;;
    --swappy) shot_swappy ;;
    *)
        echo "Usage: $0 --now | --in5 | --in10 | --area | --active | --swappy"
        exit 1
        ;;
esac