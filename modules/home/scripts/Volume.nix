{ pkgs }:

pkgs.writeShellScriptBin "volume" ''
  #!${pkgs.bash}/bin/bash
  # 🎧 Simplified Volume Control Script (Nix version)
  # Dependencies: pamixer, libnotify

  STEP_NORMAL=5
  STEP_FINE=1

  get_volume() {
      ${pkgs.pamixer}/bin/pamixer --get-volume
  }

  is_muted() {
      ${pkgs.pamixer}/bin/pamixer --get-mute
  }

  send_notification() {
      local volume=$1
      if [ "$(is_muted)" = "true" ]; then
          ${pkgs.libnotify}/bin/notify-send -e -u low "Volume: Muted"
      else
          ${pkgs.libnotify}/bin/notify-send -e -u low -h int:value:"$volume" "Volume: ${volume}%"
      fi
  }

  change_volume() {
      local delta=$1
      if [ "$(is_muted)" = "true" ]; then
          ${pkgs.pamixer}/bin/pamixer -u  # 自動でミュート解除
      fi
      ${pkgs.pamixer}/bin/pamixer -i "$delta"
      send_notification "$(get_volume)"
  }

  case "$1" in
      "--get") get_volume ;;
      "--inc") change_volume "$STEP_NORMAL" ;;
      "--dec") change_volume "-$STEP_NORMAL" ;;
      "--inc-fine") change_volume "$STEP_FINE" ;;
      "--dec-fine") change_volume "-$STEP_FINE" ;;
      "--toggle") ${pkgs.pamixer}/bin/pamixer -t && send_notification "$(get_volume)" ;;
      *) echo "Usage: $0 [--inc|--dec|--inc-fine|--dec-fine|--toggle|--get]" ;;
  esac
''
