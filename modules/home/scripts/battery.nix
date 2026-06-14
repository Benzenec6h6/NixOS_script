{pkgs, ...}:
pkgs.writeShellApplication {
  name = "battery-alert"; # コマンド名
  runtimeInputs = [pkgs.libnotify pkgs.coreutils pkgs.bash];
  text = builtins.readFile ./battery.sh;
}
