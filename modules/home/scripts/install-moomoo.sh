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

echo "Installing moomoo (Applying journal workaround)..."
distrobox enter moomoo -- bash -c "
  # 1. 偽のジャーナルディレクトリを作成してマウント
  sudo mkdir -p /tmp/dummy_journal
  sudo mount --bind /tmp/dummy_journal /var/log/journal || true
  
  # 2. dpkgに「スクリプトのエラーを無視してでも進め」と指示しつつインストール
  # ※gdebiではなく、依存関係が解決済みなので直にaptかdpkgを使うのが確実
  sudo apt install -y -o dpkg::options::=\"--force-confdef\" -o dpkg::options::=\"--force-confold\" $TMP_DEB || true
  
  # 3. もし未完了（unconfigured）状態なら、強制的に構成を完了させる
  # ここでchownエラーが出ても「|| true」で黙らせる
  sudo dpkg --configure -a || true
  
  # 4. 後片付け
  sudo umount /var/log/journal || true
  
  # 5. エクスポートを実行
  distrobox-export --app moomoo
"

rm -f "$TMP_DEB"
echo "Installation process finished (with workarounds)!"