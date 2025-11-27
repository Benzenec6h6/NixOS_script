{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  networking.networkmanager.dispatcherScripts.networkNotify = {
    source = pkgs.writeShellScript "nm-notify" ''
      #!/usr/bin/env bash

      IFACE="$1"
      ACTION="$2"

      case "$ACTION" in
        up)
          SSID=$(nmcli -t -f NAME connection show --active | head -n1)
          network-bluetooth-notify network connected "$SSID"
          ;;
        down)
          network-bluetooth-notify network disconnected
          ;;
      esac
    '';
  };
}
