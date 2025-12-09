#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$HOME/.config/rofi/myconf"

COMMON_THEME="$ROFI_DIR/common.rasi"
PW_THEME="$ROFI_DIR/password_prompt.rasi"

# --- SSID List ---
SSID=$(nmcli -t -f SSID dev wifi | sed '/^$/d' \
    | rofi -dmenu -i -theme "$COMMON_THEME" -p "Wi-Fi SSID")

[ -z "$SSID" ] && exit 0

# --- Password Prompt ---
PASS=$(rofi -dmenu -password -theme "$PW_THEME" -p "Password for $SSID")

[ -z "$PASS" ] && exit 0

# --- Connect ---
nmcli dev wifi connect "$SSID" password "$PASS"
