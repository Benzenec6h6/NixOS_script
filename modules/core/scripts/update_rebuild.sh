#!/usr/bin/env bash
set -euo pipefail

cd /etc/nixos/NixOS_script # or flake path

#echo "=== flake update ==="
#nix flake update

echo "=== system rebuild ==="

OLD_SYSTEM="$(readlink -f /run/current-system)"
OLD_KERNEL="$(uname -r)"

nixos-rebuild switch --flake .#$(hostname)

NEW_SYSTEM="$(readlink -f /run/current-system)"
NEW_KERNEL_LINK="$(readlink -f /run/current-system/kernel)"
NEW_KERNEL="$(basename "$NEW_KERNEL_LINK")"

REBOOT_REQUIRED=0
REASONS=()

# 1. system generation が変わったか
if [[ "$OLD_SYSTEM" != "$NEW_SYSTEM" ]]; then
  REBOOT_REQUIRED=1
  REASONS+=("system generation updated")
fi

# 2. kernel が変わったか
if [[ "$OLD_KERNEL" != "$NEW_KERNEL" ]]; then
  REBOOT_REQUIRED=1
  REASONS+=("kernel updated")
fi

# 3. systemd が更新されたか
if [[ "$OLD_SYSTEMD" != "$NEW_SYSTEMD" ]]; then
  REBOOT_REQUIRED=1
  REASONS+=("systemd updated")
fi

# 通知
if [[ "$REBOOT_REQUIRED" -eq 1 ]]; then
  notify-send \
    "NixOS rebuild completed" \
    "⚠ Reboot recommended:\n- $(printf '%s\n- ' "${REASONS[@]}")" \
    -u critical
else
  notify-send \
    "NixOS rebuild completed" \
    "No reboot required 🎉" \
    -u normal
fi
