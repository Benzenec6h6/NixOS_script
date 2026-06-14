#!/usr/bin/env bash
set -euo pipefail

# NetworkManagerから渡される引数
# $1: インターフェース名 (例: wlan0)
# $2: アクション名 (up, down, connectivity-change など)
INTERFACE="$1"
ACTION="$2"

# Wi-Fi（無線）以外のイベント、または無関係なアクションは即終了
if [[ ! "$INTERFACE" =~ ^wl ]]; then
    exit 0
fi

OPEN_URL="http://neverssl.com"

# rootで実行されるため、ユーザー環境のSwayNCに通知を通すおまじない
USER_ID=$(id -u "$(ls /home | head -n1)")
USER_NAME=$(ls /home | head -n1)
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

# 現在の接続SSIDを取得
SSID=$(nmcli -t -f NAME connection show --active | head -n1 || echo "")

case "$ACTION" in
    "up")
        # 接続された瞬間、NetworkManagerにネットが本当に開通しているかチェックさせる
        CONNECTIVITY=$(nmcli networking connectivity check)

        if [ "$CONNECTIVITY" = "portal" ]; then
            # キャプティブポータル（ログイン画面）が必要な場合
            sudo -u "$USER_NAME" notify-send -u critical -a "Network" -i "network-wired-symbolic" \
                "Login Required" "Wi-Fi: $SSID\nCaptive portal detected. Opening browser..."
            
            # ユーザー権限でブラウザ（ログインページ用URL）を開く
            sudo -u "$USER_NAME" xdg-open "$OPEN_URL" >/dev/null 2>&1 &
        else
            # 普通にネットに繋がった場合
            sudo -u "$USER_NAME" notify-send -a "Network" -i "network-transmit-receive-symbolic" \
                "Wi-Fi Connected" "SSID: $SSID"
        fi
        ;;

    "down")
        # 切断された瞬間
        sudo -u "$USER_NAME" notify-send -a "Network" -i "network-offline-symbolic" \
            "Wi-Fi Disconnected" "You are now offline."
        ;;
esac
