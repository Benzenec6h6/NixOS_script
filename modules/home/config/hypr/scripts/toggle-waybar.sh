#!/usr/bin/env bash

if pgrep waybar > /dev/null; then
  pkill waybar
else
  nohup waybar >/dev/null 2>&1 &
fi
