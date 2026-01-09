#!/usr/bin/env bash
set -euo pipefail

# 0..7 の数値を棒グラフの絵文字に変換する辞書を作成
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"
bar_length=${#bar}

for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

# 二重起動の防止（同じスクリプトが既に動いていたら終了させる）
# pgrep/pkill を使う方が pidfile より NixOS では安定します
current_pid=$$
for pid in $(pgrep -f "WaybarCava" || true); do
    if [ "$pid" != "$current_pid" ]; then
        kill "$pid" 2>/dev/null || true
    fi
done

# 実行
# CAVA_CONFIG_PATH は Nix 側から渡された store へのパス
exec cava -p "$CAVA_CONFIG_PATH" | sed -u "$dict"