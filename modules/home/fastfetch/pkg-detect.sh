#!/bin/sh

managers=""

# Nix
[ -d /nix/store ] && managers="nix"

# Flatpak (アプリがインストールされているかチェック)
if [ -d /var/lib/flatpak/app ] && [ "$(ls -A /var/lib/flatpak/app 2>/dev/null)" ]; then
    [ -n "$managers" ] && managers="$managers, "
    managers="${managers}flatpak"
fi

# Gentoo
if [ -d /etc/portage ]; then
    [ -n "$managers" ] && managers="$managers, "
    managers="${managers}portage"
fi

#arch
if [ -f /etc/pacman.conf ] || command -v pacman >/dev/null; then
    [ -n "$managers" ] && managers="$managers, "
    managers="${managers}pacman"
fi

echo "$managers"
