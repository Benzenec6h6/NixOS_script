{ pkgs, inputs, ... }:
pkgs.writeShellScriptBin "overview" ''
  export HYPRLAND_INSTANCE_SIGNATURE=$(cat /tmp/hypr/$(whoami)*/.instance)
  if pgrep -f quickshell.*overview.qml >/dev/null; then
    pkill -f quickshell.*overview.qml
  else
    ${inputs.quickshell.packages.${pkgs.system}.default}/bin/quickshell -p $HOME/.config/quickshell/overview.qml &
  fi
''
