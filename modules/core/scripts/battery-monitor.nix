{ config, pkgs, lib, ... }:

let
  iconDir = "/run/current-system/sw/share/icons/Papirus-Dark/24x24/symbolic/status";

  batteryMonitor = pkgs.writeShellScriptBin "battery-monitor" ''
    #!/usr/bin/env bash

    BATTERY="/sys/class/power_supply/BAT0"
    AC="/sys/class/power_supply/AC"

    capacity=$(cat "$BATTERY/capacity")
    status=$(cat "$BATTERY/status")       # Charging / Discharging / Full
    ac_online=$(cat "$AC/online")         # 1 = AC connected

    ICON_DIR="${iconDir}"

    # Low battery warning
    if [ "$capacity" -le 20 ] && [ "$ac_online" -eq 0 ]; then
        notify-send \
            --icon="$ICON_DIR/battery-caution-symbolic.svg" \
            "Battery Low" \
            "Remaining: ${capacity}%"
        exit 0
    fi

    # AC connected
    if [ "$ac_online" -eq 1 ]; then
        notify-send \
            --icon="$ICON_DIR/battery-full-charged-symbolic.svg" \
            "AC Connected" \
            "Charging / AC online"
        exit 0
    fi

    # Running on battery
    if [ "$ac_online" -eq 0 ]; then
        notify-send \
            --icon="$ICON_DIR/battery-full-symbolic.svg" \
            "Running on Battery" \
            "Remaining: ${capacity}%"
        exit 0
    fi
  '';
in
{
  ###### Systemd service ######
  systemd.services.battery-monitor = {
    description = "Battery monitor for notifications";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${batteryMonitor}/bin/battery-monitor";
    };
  };

  ###### Timer: 30秒に1回チェック ######
  systemd.timers.battery-monitor = {
    enable = true;
    description = "Periodic battery monitor";
    timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";   # 必要なら 60s などに変更可能
      Unit = "battery-monitor.service";
    };
  };
}
