#!/usr/bin/env bash
set -e

echo "Starting moomoo-installer from external script..."

# 1. コンテナ作成
distrobox create --name moomoo --image ubuntu:24.04 --yes

# 2. インストール実行
# @moomooDeb@ は後でNixが本物のパスに書き換えます
distrobox enter moomoo -- bash -c "
  sudo apt update && \
  sudo apt install -y libnss3 libasound2t64 libxss1 libgbm1 libgtk-3-0t64 libsecret-1-0 \
  libxcb-render-util0 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 \
  libxcb-image0 libxcb-keysyms1 libxcb-shape0 libxkbcommon-x11-0 \
  desktop-file-utils x11-common x11-utils libx11-xcb1 libxcb-glx0 && \
  sudo apt install -y @moomooDeb@
"

echo "Installation complete!"
