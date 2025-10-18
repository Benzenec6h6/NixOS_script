#!/usr/bin/env bash

if pgrep -f waybar > /dev/null; then
  pkill -f waybar
else
  nohup waybar >/dev/null 2>&1 &
fi
