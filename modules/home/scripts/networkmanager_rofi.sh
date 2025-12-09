#!/usr/bin/env bash
set -euo pipefail

COMMON_THEME="$HOME/.config/rofi/common.rasi"
PW_THEME="$HOME/.config/rofi/password_prompt.rasi"

# --- SSID List ---
SSID=$(nmcli -t -f SSID dev wifi | sed '/^$/d' \
    | rofi -dmenu -i -theme "$COMMON_THEME" -p "Wi-Fi SSID")

[ -z "$SSID" ] && exit 0

# --- Password Prompt ---
PASS=$(rofi -dmenu -password -theme "$PW_THEME" -p "Password for $SSID")

[ -z "$PASS" ] && exit 0

# --- Connect ---
nmcli dev wifi connect "$SSID" password "$PASS"
