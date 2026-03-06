#!/usr/bin/env bash

JSON_PATH="${KEYBINDS_JSON}"
ICON="" # SUPERのアイコン

# データの整形ロジック
# [カテゴリ] MOD + KEY -> 説明
MENU_DATA=$(jq -r '
  to_entries | .[] | .value[] | 
  "[\(.category // "Misc")] \(.mod) + \(.key) -> \(.desc)"
' "$JSON_PATH" | sort)

# Rofiで表示
echo -e "$MENU_DATA" | sed "s/SUPER/$ICON/g" | rofi \
    -dmenu -i \
    -p "Shortcuts" \
    -mesg "🔍 Search shortcuts" \
    -theme-str 'window { width: 50%; }'