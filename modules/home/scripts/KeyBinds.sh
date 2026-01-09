#!/usr/bin/env bash

# 表示設定
HEADER=" = SUPER (Win Key)"
MSG='🔍 Search or scroll to view your keybinds (Press Esc to exit)'

# --- 1. データ抽出用関数（ソースが増えたらここに追加） ---

get_hyprland_binds() {
    local file="$HYPRLAND_NIX"
    [[ ! -f "$file" ]] && return

    # Nixのbind設定行を抽出 ( "MOD, KEY, ACTION" )
    # コメントアウト( # )されている行を除外するように改善
    grep -E '^[[:space:]]*"[^"]*,[^"]*,[^"]*"' "$file" | grep -v '#' | while IFS= read -r line; do
        # クリーンアップ
        clean=$(echo "$line" | sed 's/"//g; s/^ *//; s/,$//')
        mod_key=$(echo "$clean" | cut -d',' -f1,2 | sed 's/,/ + /')
        action=$(echo "$clean" | cut -d',' -f3-)
        
        # 表示形式: [Source] Mod + Key -> Action
        echo "[Hyprland] $mod_key → $action"
    done
}

get_nvim_binds() {
    # 将来的に Neovim の keymap.lua などを解析するロジックをここに書く
    # echo "[Neovim] Space + f + f → Find files"
    :
}

# --- 2. メイン処理 ---

# 全てのソースからバインドを集約
all_binds=$(get_hyprland_binds)
all_binds+=$'\n'$(get_nvim_binds)

# 空チェック
if [[ -z "$(echo "$all_binds" | tr -d '[:space:]')" ]]; then
    notify-send "Keybinds Viewer" "⚠️ No keybinds found."
    exit 1
fi

# アイコン置換とフォーマット
display_list=$(echo "$all_binds" | sed 's/SUPER//g')
final_menu="$HEADER\n───────────────────────────────\n$display_list"

# Rofi で表示
echo -e "$final_menu" | rofi -dmenu -i -p "Shortcuts" -mesg "$MSG" -theme-str 'window { width: 40%; }'