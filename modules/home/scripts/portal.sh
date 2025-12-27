#!/usr/bin/env bash
set -euo pipefail

OPEN_URL="http://neverssl.com"

connectivity="$(nmcli -t -f CONNECTIVITY general 2>/dev/null || true)"

# Captive portal detected
if [ "$connectivity" = "portal" ]; then
    xdg-open "$OPEN_URL" >/dev/null 2>&1 &
    exit 0
fi

exit 0
