#!/usr/bin/env bash
set -euo pipefail

RESUME_FILE=$(< /run/resume_file 2>/dev/null || true)
RESUME_OFFSET=$(< /run/resume_offset 2>/dev/null || true)

if [ -n "$RESUME_FILE" ] && [ -n "$RESUME_OFFSET" ]; then
  echo "Using dynamic resume file: $RESUME_FILE (offset $RESUME_OFFSET)"
  printf "%s" "$RESUME_FILE" > /sys/power/resume
  printf "%s" "$RESUME_OFFSET" > /sys/power/resume_offset
else
  echo "No dynamic resume data found"
fi
