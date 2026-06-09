{
  pkgs,
  lib,
  vars,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:Benzenec6h6/NixOS_script";
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "20min";
    upgrade = false;
    flags = [
      "--no-write-lock-file"
    ];
  };

  systemd.services.nixos-upgrade = {
    # path を直接指定することで、全スクリプト（pre/post）で利用可能になります
    path = with pkgs; [
      nix
      gawk
      coreutils
      libnotify
      sudo
      systemd
    ];

    # アップグレード前の世代番号を記録
    preStart = lib.mkAfter ''
      # パスをフルパスで指定するか、上記の 'path' 設定に頼る
      nix-env -p /nix/var/nix/profiles/system --list-generations \
        | ${pkgs.coreutils}/bin/tail -n 1 \
        | ${pkgs.gawk}/bin/awk '{print $1}' \
        > /run/nixos-upgrade-before-gen
    '';

    postStop = lib.mkAfter ''
      # サービスの終了コードを確認
      if [ "$SERVICE_RESULT" != "success" ]; then
        echo "Upgrade did not succeed (result: $SERVICE_RESULT). Skipping notification."
        exit 0
      fi

      BEFORE_GEN=$(cat /run/nixos-upgrade-before-gen 2>/dev/null || echo "0")
      # ここもフルパス指定、または path 環境変数を利用
      LATEST_GEN_INFO=$(nix-env -p /nix/var/nix/profiles/system --list-generations | ${pkgs.coreutils}/bin/tail -n 1)
      AFTER_GEN=$(echo "$LATEST_GEN_INFO" | ${pkgs.gawk}/bin/awk '{print $1}')

      rm -f /run/nixos-upgrade-before-gen

      if [ "$BEFORE_GEN" = "$AFTER_GEN" ]; then
        echo "No new generation (still at $BEFORE_GEN). Skipping notification."
        exit 0
      fi

      TARGET_USER="${vars.user.name}"
      USER_ID=$(id -u "$TARGET_USER")

      systemd-run \
        --uid="$USER_ID" \
        --property="Environment=DISPLAY=:0" \
        --property="PAMName=login" \
        -- \
        ${pkgs.libnotify}/bin/notify-send \
          --icon=system-software-update \
          "System Upgrade Complete" \
          "System updated to Generation $AFTER_GEN." \
        || true
    '';
  };
}
