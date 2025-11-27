#!/usr/bin/env bash

# Get active window info
info=$(hyprctl activewindow -j 2>/dev/null) || exit 1
pid=$(echo "$info" | jq -r '.pid')

# 1) Safe close
hyprctl dispatch closewindow

# 1秒待つ
sleep 1

# Still alive?
if kill -0 "$pid" 2>/dev/null; then
    echo "Safe close failed → force closing..."
    hyprctl dispatch killactive
    sleep 1
fi

# Still alive? brute kill (fallback)
if kill -0 "$pid" 2>/dev/null; then
    echo "Force close failed → SIGKILL..."
    kill -9 "$pid"
fi
