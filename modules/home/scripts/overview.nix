{ pkgs }:
pkgs.writeShellScriptBin "overview" ''
  pgrep -f overview.qml >/dev/null && pkill -f overview.qml || quickshell ''$HOME/.config/quickshell/overview.qml
''
