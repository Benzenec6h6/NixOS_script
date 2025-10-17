#!/usr/bin/env bash

term="kitty"      # Default terminal emulator
files="thunar"    # Default file manager
editor="${EDITOR:-nano}"
search_engine="https://www.google.com/search?q={}"

# Check for dependencies
for cmd in "$term" "$files" notify-send; do
  if ! command -v "$cmd" &>/dev/null; then
    notify-send "⚠️ Missing dependency" "Command not found: $cmd"
  fi
done

# Execute accordingly based on the passed argument
if [[ "$1" == "--btop" ]]; then
    $term --title btop sh -c 'btop'
elif [[ "$1" == "--nvtop" ]]; then
    $term --title nvtop sh -c 'nvtop'
elif [[ "$1" == "--nmtui" ]]; then
    $term nmtui
elif [[ "$1" == "--term" ]]; then
    $term &
elif [[ "$1" == "--files" ]]; then
    $files &
else
    echo "Usage: $0 [--btop | --nvtop | --nmtui | --term]"
    echo "--btop       : Open btop in a new term"
    echo "--nvtop      : Open nvtop in a new term"
    echo "--nmtui      : Open nmtui in a new term"
    echo "--term   : Launch a term window"
    echo "--files  : Launch a file manager"
fi