#!/usr/bin/env bash

notify_event() {
    local icon="$1"
    local title="$2"
    local message="$3"

    notify-send \
        -e \
        -u low \
        -h boolean:SWAYNC_BYPASS_DND:true \
        -i "$icon" \
        "$title" "$message"
}

if [[ "$1" == "network" ]]; then
    case "$2" in
        connected)
            notify_event "network-transmit-receive-symbolic" \
                "Network" "Connected: $3"
            ;;
        disconnected)
            notify_event "network-offline-symbolic" \
                "Network" "Disconnected"
            ;;
    esac
fi

if [[ "$1" == "bluetooth" ]]; then
    case "$2" in
        connected)
            notify_event "bluetooth-active-symbolic" \
                "Bluetooth" "Connected: $3"
            ;;
        disconnected)
            notify_event "bluetooth-disabled-symbolic" \
                "Bluetooth" "Disconnected"
            ;;
    esac
fi
