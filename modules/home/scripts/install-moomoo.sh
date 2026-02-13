#!/usr/bin/env bash
set -e

DEB_SRC="@moomooDeb@"
# _aptユーザもアクセスできる /tmp にコピーする
TMP_DEB="$HOME/moomoo_install.deb"

echo "Copying deb to /tmp..."
cp "$DEB_SRC" "$TMP_DEB"
chmod 644 "$TMP_DEB" # 誰でも読めるように権限付与
ls -l "$TMP_DEB"

echo "Creating Distrobox container..."
distrobox create --name moomoo --image ubuntu:22.04 --yes

echo "Ensure dependencies are aligned..."
distrobox enter moomoo -- bash -c "
  sudo apt update && \
  sudo apt install -y \
    libnss3 libasound2 libxss1 libgbm1 libgtk-3-0 libsecret-1-0 \
    libxcb-render-util0 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-shape0 libxkbcommon-x11-0 \
    desktop-file-utils libgl1-mesa-glx \
    wget gdebi-core
"

echo "Installing moomoo inside container..."
distrobox enter moomoo -- bash -c "
  sudo gdebi -n $TMP_DEB && \
  distrobox-export --app moomoo
"

rm "$TMP_DEB"
echo "Installation and Export complete!"