#!/bin/bash

# Waybarが自動で以下の環境変数をセットして実行してくれます：
# $STATUS     : "Charging", "Discharging", "Full" など
# $CAPACITY    : バッテリー残量の数値（例: 25）

# 充電中・満充電時は何もしない
if [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
    exit 0
fi

# Waybar側から引数で渡された $state を受け取る（"warning" や "critical"）
STATE=$1

if [ "$STATE" = "critical" ]; then
    notify-send -u critical -i battery-empty \
        "バッテリー残量が深刻です" \
        "残り ${CAPACITY}% です。至急充電してください。"
elif [ "$STATE" = "warning" ]; then
    notify-send -u normal -i battery-caution \
        "バッテリー残量低下" \
        "残り ${CAPACITY}% です。"
fi
