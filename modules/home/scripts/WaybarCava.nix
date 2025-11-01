{ pkgs }:

pkgs.writeShellScriptBin "waybar-cava" ''
  #!${pkgs.bash}/bin/bash
  # WaybarCava (Nix version)
  # Dependencies: cava, coreutils, sed

  set -euo pipefail

  # Ensure cava exists
  if ! command -v ${pkgs.cava}/bin/cava >/dev/null 2>&1; then
    echo "cava not found" >&2
    exit 1
  fi

  # 0..7 → ▁▂▃▄▅▆▇█
  bar="▁▂▃▄▅▆▇█"
  dict="s/;//g"
  bar_length=${#bar}
  for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
  done

  # Single-instance guard
  RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
  pidfile="$RUNTIME_DIR/waybar-cava.pid"
  if [[ -f "$pidfile" ]]; then
    oldpid="$(${pkgs.coreutils}/bin/cat "$pidfile" || true)"
    if [[ -n "$oldpid" ]] && kill -0 "$oldpid" 2>/dev/null; then
      kill "$oldpid" 2>/dev/null || true
      sleep 0.1 || true
    fi
  fi
  printf '%d' $$ >"$pidfile"

  # Unique temp config + cleanup
  config_file="$(${pkgs.coreutils}/bin/mktemp "$RUNTIME_DIR/waybar-cava.XXXXXX.conf")"
  cleanup() { ${pkgs.coreutils}/bin/rm -f "$config_file" "$pidfile"; }
  trap cleanup EXIT INT TERM

  cat >"$config_file" <<EOF
[general]
framerate = 30
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

  # Stream cava output
  exec ${pkgs.cava}/bin/cava -p "$config_file" | ${pkgs.gnused}/bin/sed -u "$dict"
''
