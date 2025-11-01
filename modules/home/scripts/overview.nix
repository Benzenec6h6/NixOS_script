{ pkgs }:
pkgs.writeShellScriptBin "overview" ''
  pgrep -f overview.qml >/dev/null && pkill -f overview.qml || quickshell ${config.home.homeDirectory}/.config/quickshell/overview.qml
''
