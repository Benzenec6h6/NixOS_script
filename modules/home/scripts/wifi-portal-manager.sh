#!/usr/bin/env bash

last_ssid=""
OPEN_URL="http://neverssl.com"

echo "Starting Wi-Fi Portal Manager..."

while true; do
    # 現在の接続状況を確認
    # nmcli connectivity check は実際に外部通信を試みるため、正確なポータル判定が可能です
    connectivity=$(nmcli networking connectivity check)
    ssid=$(nmcli -t -f NAME connection show --active | head -n1 || echo "")

    # 1. 接続先が変わった、または切断された場合
    if [ "$ssid" != "$last_ssid" ]; then
        if [ -n "$ssid" ]; then
            if [ "$connectivity" = "portal" ]; then
                notify-send -u critical -a "Network" -i "network-wired-symbolic" \
                    "Login Required" "Wi-Fi: $ssid\nCaptive portal detected. Opening browser..."
                xdg-open "$OPEN_URL" >/dev/null 2>&1 &
            else
                notify-send -a "Network" -i "network-transmit-receive-symbolic" \
                    "Wi-Fi Connected" "SSID: $ssid"
            fi
        else
            notify-send -a "Network" -i "network-offline-symbolic" \
                "Wi-Fi Disconnected" "You are now offline."
        fi
        last_ssid="$ssid"
    fi

    # 2. ポータル状態が続いている場合の再通知（1分おき程度に抑制）
    if [ -n "$ssid" ] && [ "$connectivity" = "portal" ]; then
        # ログインするまでブラウザを開き続けると鬱陶しいので、
        # ここではループのウェイトを少し長めにするか、何もしない
        sleep 20
    fi
    
    # 監視間隔（10秒）
    sleep 10
done