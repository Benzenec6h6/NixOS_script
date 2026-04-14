#!/usr/bin/env bash
set -euo pipefail

# Command handler
TERM_EXE = "${termcmd}"
case "${1:-}" in
    "--btop")
        "$TERM_EXE" --title "System Monitor (btop)" -e btop
        ;;
    "--nvtop")
        "$TERM_EXE" --title "GPU Monitor (nvtop)" -e nvtop
        ;;
    "--nmtui")
        "$TERM_EXE" --title "Network Manager" -e nmtui
        ;;
    "--term")
        "$TERM_EXE" &
        ;;
    "--files")
        thunar &
        ;;
    *)
        echo "Usage: $0 [--btop | --nvtop | --nmtui | --term | --files]"
        exit 1
        ;;
esac
