#!/usr/bin/env bash
set -e

# Nixから注入された .deb パス
DEB_SRC="@moomooDeb@"
# 一時的なコピー先（Distroboxから見えるホームディレクトリ下など）
TMP_DEB="$HOME/.moomoo_install.deb"

echo "Copying deb from Nix store to home..."
cp "$DEB_SRC" "$TMP_DEB"

echo "Creating Distrobox container..."
distrobox create --name moomoo --image ubuntu:22.04 --yes

echo "Installing moomoo inside container..."
distrobox enter moomoo -- bash -c "
  sudo apt update && \
  sudo apt install -y libnss3 libasound2t64 libxss1 libgbm1 libgtk-3-0t64 libsecret-1-0 \
  libxcb-render-util0 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 \
  libxcb-image0 libxcb-keysyms1 libxcb-shape0 libxkbcommon-x11-0 \
  desktop-file-utils x11-common x11-utils libx11-xcb1 libxcb-glx0 && \
  sudo apt install -y $TMP_DEB && \
  distrobox-export --app moomoo
"

# 後片付け
rm "$TMP_DEB"
echo "Installation and Export complete!"