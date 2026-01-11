#!/usr/bin/env bash
set -euo pipefail

TERMINAL_CMD="kitty --class kitty-dropterm --title dropterm"
SPECIAL_WS="special:scratchpad"
ADDR_FILE="/tmp/dropterminal.addr"

spawn_terminal() {
  hyprctl dispatch exec "${TERMINAL_CMD}"
}

# address を探す（class で決め打ち）
get_addr() {
  hyprctl clients -j | jq -r '
    .[] | select(.class=="kitty-dropterm") | .address
  ' | head -n1
}

addr="$(get_addr)"

if [ -z "$addr" ]; then
  spawn_terminal
  sleep 0.1
  addr="$(get_addr)"
fi

# toggle
if hyprctl clients -j | jq -e --arg a "$addr" \
  'any(.[]; .address==$a and .workspace.name=="'"$SPECIAL_WS"'")' \
  >/dev/null; then
  hyprctl dispatch movetoworkspacesilent "active,address:$addr"
  hyprctl dispatch focuswindow "address:$addr"
else
  hyprctl dispatch movetoworkspacesilent "$SPECIAL_WS,address:$addr"
fi
