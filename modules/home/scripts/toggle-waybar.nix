{ pkgs }:

pkgs.writeShellScriptBin "toggle-waybar" ''
  #!${pkgs.bash}/bin/bash
  # 🧩 Toggle Waybar visibility
  # Dependencies: procps (pgrep, pkill), waybar

  if ${pkgs.procps}/bin/pgrep -f waybar > /dev/null; then
    ${pkgs.procps}/bin/pkill -f waybar
  else
    hyprctl dispatch exec "${pkgs.waybar}/bin/waybar"
  fi
''
