#!/usr/bin/env bash

ICON_DIR="/run/current-system/sw/share/icons/Papirus-Light/24x24/symbolic/status/"

notify_event() {
    local icon="$1"
    local title="$2"
    local message="$3"

    notify-send \
        -e \
        -u low \
        -h boolean:SWAYNC_BYPASS_DND:true \
        -i "$ICON_DIR/$icon" \
        "$title" "$message"
}

if [[ "$1" == "network" ]]; then
    case "$2" in
        connected)
            notify_event "network-transmit-receive-symbolic.svg" \
                "Network" "Connected: $3"
            ;;
        disconnected)
            notify_event "network-offline-symbolic.svg" \
                "Network" "Disconnected"
            ;;
    esac
fi

if [[ "$1" == "bluetooth" ]]; then
    case "$2" in
        connected)
            notify_event "bluetooth-active-symbolic.svg" \
                "Bluetooth" "Connected: $3"
            ;;
        disconnected)
            notify_event "bluetooth-disabled-symbolic.svg" \
                "Bluetooth" "Disconnected"
            ;;
    esac
fi
