#!/usr/bin/env bash

# 表示設定
HEADER="${SUPER_ICON} = SUPER (Win Key)"
MSG='🔍 Search or scroll to view your keybinds (Press Esc to exit)'

# --- 1. データ抽出用関数 ---

get_hyprland_bind() {
    local file="$HYPRLAND_NIX"
    [[ ! -f "$file" ]] && return

    awk '
        $0 ~ /^[[:space:]]*bind[[:space:]]*=[[:space:]]*\[/ { in=1; next }
        in && $0 ~ /^[[:space:]]*\];/ { in=0 }
        in
    ' "$file" \
    | grep -v '^[[:space:]]*#' \
    | grep -E '"[^"]+"' \
    | while IFS= read -r line; do
        clean=$(echo "$line" | sed 's/"//g; s/^ *//; s/,$//')
        mod_key=$(echo "$clean" | cut -d',' -f1,2 | sed 's/,/ + /')
        action=$(echo "$clean" | cut -d',' -f3-)

        echo "[Hyprland:Bind] $mod_key → $action"
    done
}

get_hyprland_bindl() {
    local file="$HYPRLAND_NIX"
    [[ ! -f "$file" ]] && return

    awk '
        $0 ~ /^[[:space:]]*bindl[[:space:]]*=[[:space:]]*\[/ { in=1; next }
        in && $0 ~ /^[[:space:]]*\];/ { in=0 }
        in
    ' "$file" \
    | grep -v '^[[:space:]]*#' \
    | grep -E '"[^"]+"' \
    | while IFS= read -r line; do
        clean=$(echo "$line" | sed 's/"//g; s/^ *//; s/,$//')
        mod_key=$(echo "$clean" | cut -d',' -f1,2 | sed 's/,/ + /')
        action=$(echo "$clean" | cut -d',' -f3-)

        echo "[Hyprland:BindL] $mod_key → $action"
    done
}

# --- 2. メイン処理 ---

binds=$(get_hyprland_bind)
bindls=$(get_hyprland_bindl)

# bind だけ SUPER → ICON
binds="${binds//SUPER/${SUPER_ICON}}"

all_binds="$binds"$'\n'"$bindls"

# 空チェック
if [[ -z "$(echo "$all_binds" | tr -d '[:space:]')" ]]; then
    notify-send "Keybinds Viewer" "⚠️ No keybinds found."
    exit 1
fi

final_menu="$HEADER\n───────────────────────────────\n$all_binds"

# Rofi で表示
echo -e "$final_menu" | rofi -dmenu -i -p "Shortcuts" -mesg "$MSG" -theme-str 'window { width: 40%; }'
