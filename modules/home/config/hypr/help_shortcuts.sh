#!/usr/bin/env bash

# ショートカット一覧ファイルのパス
SHORTCUTS_FILE="$HOME/.config/hypr/shortcuts.txt"

# rofi を使ってショートカットを検索・表示する
if [ -f "$SHORTCUTS_FILE" ]; then
    rofi -dmenu \
        -i \
        -p "Shortcuts" \
        -theme-str 'window {width: 50%;}' \
        < "$SHORTCUTS_FILE"
else
    notify-send "Shortcuts file not found!" "$SHORTCUTS_FILE"
fi
