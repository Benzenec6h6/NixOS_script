{
  systemd.services.bluetooth-notify = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = pkgs.writeShellScript "bt-notify-install" ''
        #!/usr/bin/env bash

        HOOK_DIR="/usr/libexec/bluetooth"
        mkdir -p "$HOOK_DIR"

        cat <<'EOF' > "$HOOK_DIR/notify-hook"
#!/usr/bin/env bash

ACTION="$1"
DEVICE_NAME="$NAME"

case "$ACTION" in
  connect*)
    network-bluetooth-notify bluetooth connected "$DEVICE_NAME"
    ;;
  disconnect*)
    network-bluetooth-notify bluetooth disconnected "$DEVICE_NAME"
    ;;
esac
EOF

        chmod +x "$HOOK_DIR/notify-hook"
      '';
    };
  };
}
