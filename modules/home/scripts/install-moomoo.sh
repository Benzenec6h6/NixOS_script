#!/usr/bin/env bash
set -e

DEB_SRC="@moomooDeb@"
TMP_DEB="$HOME/moomoo_install.deb"

# 前回の残骸を掃除
distrobox rm moomoo --force || true

echo "Copying deb..."
cp "$DEB_SRC" "$TMP_DEB"
chmod 644 "$TMP_DEB"

echo "Creating Distrobox container..."
distrobox create --name moomoo --image ubuntu:22.04 --yes

echo "Installing base dependencies..."
distrobox enter moomoo -- bash -c "
  sudo apt update && \
  sudo apt install -y \
    libnss3 libasound2 libxss1 libgbm1 libgtk-3-0 libsecret-1-0 \
    libxcb-render-util0 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-shape0 libxkbcommon-x11-0 \
    desktop-file-utils libgl1-mesa-glx \
    wget gdebi-core
"

echo "Installing moomoo (Bypassing preinst chown checks)..."
distrobox enter moomoo -- bash -c "
  # 1. chown を一時的にダミー（/bin/true）に置き換える
  # これにより、インストーラーが何に対してchownを試みても「成功」扱いになります
  sudo mv /usr/bin/chown /usr/bin/chown.bak
  sudo ln -s /bin/true /usr/bin/chown

  # 2. インストール実行
  # 権限エラーが出ても無視して進むよう || true を付与
  sudo apt install -y $TMP_DEB || true
  
  # 3. 未完了状態を強制的に構成
  sudo dpkg --configure -a || true

  # 4. chown を元に戻す（重要）
  sudo rm /usr/bin/chown
  sudo mv /usr/bin/chown.bak /usr/bin/chown
  
  # 5. エクスポートを実行
  # インストールが「半分失敗」に見えても、ファイルさえ置けていればエクスポート可能です
  distrobox-export --app moomoo
"

rm -f "$TMP_DEB"
echo "Installation process finished (with workarounds)!"