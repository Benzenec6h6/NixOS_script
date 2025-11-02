{ pkgs }:

pkgs.writeShellScriptBin "waybar-scripts" ''
  #!${pkgs.bash}/bin/bash
  # WaybarScripts (Nix version)
  # Dependencies: kitty, thunar, notify-send, btop, nvtop, nmtui

  set -euo pipefail

  term="kitty"
  files="thunar"
  editor="${EDITOR:-nano}"
  search_engine="https://www.google.com/search?q={}"

  # Check dependencies
  for cmd in "$term" "$files" ${pkgs.libnotify}/bin/notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
      ${pkgs.libnotify}/bin/notify-send "⚠️ Missing dependency" "Command not found: $cmd"
    fi
  done

  # Command handler
  case "$1" in
    "--btop")
      ${pkgs.kitty}/bin/kitty --title btop sh -c '${pkgs.btop}/bin/btop'
      ;;
    "--nvtop")
      ${pkgs.kitty}/bin/kitty --title nvtop sh -c '${pkgs.nvtopPackages.full}/bin/nvtop'
      ;;
    "--nmtui")
      ${pkgs.kitty}/bin/kitty ${pkgs.networkmanager}/bin/nmtui
      ;;
    "--term")
      ${pkgs.kitty}/bin/kitty &
      ;;
    "--files")
      ${pkgs.xfce.thunar}/bin/thunar &
      ;;
    *)
      echo "Usage: $0 [--btop | --nvtop | --nmtui | --term | --files]"
      echo "--btop   : Open btop in a new terminal"
      echo "--nvtop  : Open nvtop in a new terminal"
      echo "--nmtui  : Launch Network Manager TUI"
      echo "--term   : Launch terminal window"
      echo "--files  : Launch file manager"
      ;;
  esac
''
