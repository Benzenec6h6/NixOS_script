#!/usr/bin/env bash

# Rofiのテーマパス（存在確認付き）
ROFI_THEME="$HOME/.config/rofi/config-clipboard.rasi"
MSG='👀 <b>Note</b>: <span color="#ff6666">Ctrl+Del</span>: Delete entry | <span color="#ff6666">Alt+Del</span>: Wipe all'

# 既に起動している場合は一旦終了させる
if pidof rofi > /dev/null; then
    pkill rofi
fi

# Rofiの引数を配列にまとめる（読みやすさのため）
ROFI_ARGS=(
    "-dmenu"
    "-i"
    "-p" "Clipboard"
    "-mesg" "$MSG"
    "-kb-custom-1" "Control+Delete"
    "-kb-custom-2" "Alt+Delete"
    "-markup-rows" # HTMLタグを有効にする（MSGの色付けなど）
)

# テーマファイルが存在する場合のみ適用
if [[ -f "$ROFI_THEME" ]]; then
    ROFI_ARGS+=("-config" "$ROFI_THEME")
fi

# メインループ（特定の操作時以外はループを抜ける設計に）
while true; do
    # 履歴リストの取得
    list=$(cliphist list)
    if [[ -z "$list" ]]; then
        notify-send -u low "Clipboard" "History is empty"
        exit 0
    fi

    # Rofi起動
    result=$(echo "$list" | rofi "${ROFI_ARGS[@]}")
    exit_code=$?

    case "$exit_code" in
        0) # 選択して決定（通常コピー）
            if [[ -n "$result" ]]; then
                echo "$result" | cliphist decode | wl-copy
            fi
            exit 0
            ;;
        1) # キャンセル（Escや外側をクリック）
            exit 0
            ;;
        10) # Control+Delete (Delete entry)
            if [[ -n "$result" ]]; then
                echo "$result" | cliphist delete
                # 削除後はリストを更新して再表示するため、ループを継続
            fi
            ;;
        11) # Alt+Delete (Wipe all)
            cliphist wipe
            notify-send -u low "Clipboard" "History wiped"
            exit 0
            ;;
        *)
            exit 0
            ;;
    esac
done