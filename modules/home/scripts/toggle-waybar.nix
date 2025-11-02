{ pkgs }:

pkgs.writeShellScriptBin "toggle-waybar" ''
  #!${pkgs.bash}/bin/bash
  # 🧩 Toggle Waybar visibility
  # Dependencies: procps (pgrep, pkill), waybar

  if ${pkgs.procps}/bin/pgrep -f waybar > /dev/null; then
    ${pkgs.procps}/bin/pkill -f waybar
  else
    # 環境変数を維持して Waybar を再起動
    env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
      ${pkgs.waybar}/bin/waybar >/dev/null 2>&1 &
  fi
''
