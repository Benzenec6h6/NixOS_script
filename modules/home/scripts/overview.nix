{ pkgs }:
pkgs.writeShellScriptBin "overview" ''
  export HYPRLAND_INSTANCE_SIGNATURE=$(cat /tmp/hypr/$(whoami)*/.instance)
  if pgrep -f quickshell.*overview.qml >/dev/null; then
    pkill -f quickshell.*overview.qml
  else
    ${pkgs.quickshell}/bin/quickshell -p $HOME/.config/quickshell/overview.qml &
  fi
''
