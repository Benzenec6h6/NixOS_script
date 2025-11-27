#!/usr/bin/env bash

#==============================
#  Screenshot Script for Hyprland (NixOS optimized)
#==============================

# timestamp & file info
time=$(date "+%Y-%m-%d_%H-%M-%S")
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}.png"
path="${dir}/${file}"

# dirs
ICON_DIR="$HOME/.config/swaync/icons"
IMAGE_DIR="$HOME/.config/swaync/images"

# sounds (NixOS fixed paths)
SND_CAPTURE="/run/current-system/sw/share/sounds/freedesktop/stereo/screen-capture.oga"
SND_ERROR="/run/current-system/sw/share/sounds/freedesktop/stereo/dialog-error.oga"

# notify templates
notify_ok="notify-send -t 8000 -A open=Open -A del=Delete -i ${ICON_DIR}/picture.png -h string:x-canonical-private-synchronous:shot"
notify_err="notify-send -u low -i ${IMAGE_DIR}/note.png"

# play sound safely
playsound() {
    pw-play "$1" 2>/dev/null
}

# unified notification handler
show_notify() {
    local p="$1"
    if [[ -e "$p" ]]; then
        playsound "$SND_CAPTURE"
        resp=$(timeout 5 $notify_ok "Screenshot saved" "$p")
        case "$resp" in
            open) xdg-open "$p" & ;;
            del)  rm "$p" ;;
        esac
    else
        playsound "$SND_ERROR"
        $notify_err "Screenshot" "Failed to save"
    fi
}

# ensure screenshot dir exists
mkdir -p "$dir"

#===== screenshot actions =====#

shot_now() {
    grim > "$path"
    wl-copy < "$path"
    show_notify "$path"
}

shot_timer() {
    local sec="$1"
    for s in $(seq "$sec" -1 1); do
        notify-send -t 1000 -i "$ICON_DIR/timer.png" "Screenshot in…" "$s seconds"
        sleep 1
    done
    shot_now
}

shot_area() {
    tmp=$(mktemp)
    if grim -g "$(slurp)" - > "$tmp"; then
        mv "$tmp" "$path"
        wl-copy < "$path"
        show_notify "$path"
    else
        playsound "$SND_ERROR"
        $notify_err "Area capture failed"
    fi
}

shot_window() {
    info=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    grim -g "$info" > "$path"
    wl-copy < "$path"
    show_notify "$path"
}

shot_active() {
    class=$(hyprctl -j activewindow | jq -r '.class')
    wfile="Screenshot_${time}_${class}.png"
    wpath="${dir}/${wfile}"

    info=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    grim -g "$info" > "$wpath"
    wl-copy < "$wpath"
    show_notify "$wpath"
}

shot_swappy() {
    tmp=$(mktemp)
    grim -g "$(slurp)" - > "$tmp"
    if [[ -s "$tmp" ]]; then
        wl-copy < "$tmp"
        notify-send -t 6000 -A edit=Edit -i ${ICON_DIR}/picture.png "Screenshot captured" "Swappy mode"
        swappy -f - < "$tmp"
    else
        playsound "$SND_ERROR"
    fi
}

#===== CLI dispatcher =====#

case "$1" in
    --now)      shot_now ;;
    --in5)      shot_timer 5 ;;
    --in10)     shot_timer 10 ;;
    --area)     shot_area ;;
    --win)      shot_window ;;
    --active)   shot_active ;;
    --swappy)   shot_swappy ;;
    *)
        echo "Usage: $0 --now | --in5 | --in10 | --win | --area | --active | --swappy"
        exit 1
        ;;
esac

exit 0
