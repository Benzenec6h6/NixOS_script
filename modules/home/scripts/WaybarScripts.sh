#!/usr/bin/env bash
set -euo pipefail

# Command handler
case "${1:-}" in
    "--btop")
        kitty --title "System Monitor (btop)" -e btop
        ;;
    "--nvtop")
        kitty --title "GPU Monitor (nvtop)" -e nvtop
        ;;
    "--nmtui")
        kitty --title "Network Manager" -e nmtui
        ;;
    "--term")
        kitty &
        ;;
    "--files")
        thunar &
        ;;
    *)
        echo "Usage: $0 [--btop | --nvtop | --nmtui | --term | --files]"
        exit 1
        ;;
esac