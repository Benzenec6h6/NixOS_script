{ pkgs }:

pkgs.writeShellScriptBin "brightness" ''
  #!${pkgs.bash}/bin/bash

  STEP_NORMAL=5
  STEP_FINE=1

  ICON_DIR="/run/current-system/sw/share/icons/Papirus-Light/24x24/symbolic/status"
  ICON="$ICON_DIR/display-brightness-high-symbolic.svg"

  get_brightness() {
      ${pkgs.brightnessctl}/bin/brightnessctl -m | cut -d, -f4 | tr -d '%'
  }

  send_notification() {
      local brightness=$1
      ${pkgs.libnotify}/bin/notify-send \
          --icon="$ICON" \
          -e \
          -h string:x-canonical-private-synchronous:brightness_notif \
          -h int:value:"$brightness" \
          -u low \
          "Brightness: ''${brightness}%"
  }

  change_brightness() {
      local delta=$1
      local current new

      current=$(get_brightness)
      new=$((current + delta))

      (( new < 0 )) && new=0
      (( new > 100 )) && new=100

      ${pkgs.brightnessctl}/bin/brightnessctl set "''${new}%"
      send_notification "$new"
  }

  case "$1" in
      "--get")
          get_brightness
          ;;
      "--inc")
          change_brightness "$STEP_NORMAL"
          ;;
      "--dec")
          change_brightness "-$STEP_NORMAL"
          ;;
      "--inc-fine")
          change_brightness "$STEP_FINE"
          ;;
      "--dec-fine")
          change_brightness "-$STEP_FINE"
          ;;
      *)
          echo "Usage: $0 [--inc|--dec|--inc-fine|--dec-fine|--get]"
          ;;
  esac
''
