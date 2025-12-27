#!/usr/bin/env bash

VIDEO="$1"

# 既存の mpv 壁紙を止める
pkill -f "mpv.*--title=mpv-wallpaper" 2>/dev/null

# 起動
mpv "$VIDEO" \
  --loop \
  --no-audio \
  --fullscreen \
  --ontop=no \
  --border=no \
  --title=mpv-wallpaper \
  --panscan=1.0 \
  --hwdec=auto \
  --player-operation-mode=pseudo-gui
