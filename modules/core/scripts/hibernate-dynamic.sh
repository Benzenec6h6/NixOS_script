#!/usr/bin/env bash
set -euo pipefail

SWAPFILE="/swapfile-hibernate"

# 1. 現在使用中のメモリの計算（キャッシュを除いた実使用量）
TOTAL_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
AVAIL_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
USED_KB=$((TOTAL_KB - AVAIL_KB))

# 2. 安全マージン（1.2 倍）
NEEDED_KB=$((USED_KB * 12 / 10))

echo "Hibernate requires ~$((NEEDED_KB/1024)) MB swap."

# 3. swapfile の作り直し
if [ -f "$SWAPFILE" ]; then
    # まず swap として使われているかチェック
    if swapon --show | grep -q "$SWAPFILE"; then
        echo "Swapfile in use. Trying to swapoff..."
        if ! swapoff "$SWAPFILE"; then
            echo "swapoff failed. Aborting." >&2
            exit 1
        fi
    fi

    # swapfile が存在しているなら削除
    blkdiscard "$SWAPFILE" 2>/dev/null || true
    rm -f "$SWAPFILE"
fi

echo "Allocating swapfile: $((NEEDED_KB/1024)) MB…"
if command -v fallocate >/dev/null; then
    fallocate -l ${NEEDED_KB}K "$SWAPFILE"
else
    dd if=/dev/zero of="$SWAPFILE" bs=1K count="$NEEDED_KB" status=progress
fi
chmod 600 "$SWAPFILE"
mkswap "$SWAPFILE"
swapon "$SWAPFILE"

# 4. resume_offset 計算
OFFSET=$(filefrag -v "$SWAPFILE" | awk '$1=="0:" && $4 ~ /^[0-9]/ {print $4}' | sed 's/\.\.//')
echo "resume_offset=$OFFSET"

# 5. 更新情報を保存して initrd に通知できるようにする
echo "$OFFSET" > /run/resume_offset
echo "$SWAPFILE" > /run/resume_file

# 6. Hibernate 実行
sync
systemctl hibernate
