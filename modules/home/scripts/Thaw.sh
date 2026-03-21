#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: thaw <archive>..."
  exit 1
fi

extract_one() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo "extract: '$file' is not a file" >&2
    return 1
  fi

  case "$file" in
    # tar系はオプションをまとめられるので集約
    *.tar|*.tar.gz|*.tgz|*.tar.xz|*.txz|*.tar.bz2|*.tbz2|*.tar.zst)
      tar -xvf "$file" ;;
    
    # ZIP, 7z, RAR は unar に任せる（文字化け・散らかり防止）
    *.zip|*.7z|*.rar)
      unar "$file" ;;

    # 単一ファイルの圧縮
    *.gz)   pigz -dk "$file" ;;
    *.xz)   pixz -d "$file" ;;
    *.bz2)  pbzip2 -dk "$file" ;;
    *.zst)  zstd -dk "$file" ;;

    *)
      # 対応外の拡張子でも unar が扱える可能性があるので試行
      echo "extract: unknown extension, trying with unar: $file" >&2
      if ! unar "$file"; then
        echo "extract: failed to extract '$file'" >&2
        return 2
      fi
      ;;
  esac
}

for f in "$@"; do
  echo "==> Extracting: $f"
  extract_one "$f"
done
