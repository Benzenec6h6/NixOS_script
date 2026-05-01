{ pkgs, lib, vars, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:Benzenec6h6/NixOS_script";
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "20min";
  };

  systemd.services.nixos-upgrade = {
    serviceConfig = {
      # パッケージの /bin を PATH に追加（正しい形式）
      ExecSearchPath = lib.makeBinPath [
        pkgs.nix
        pkgs.gawk
        pkgs.coreutils
        pkgs.libnotify
        pkgs.sudo
      ];
    };

    # アップグレード前の世代番号を記録
    preStart = lib.mkAfter ''
      nix-env -p /nix/var/nix/profiles/system --list-generations \
        | tail -n 1 \
        | awk '{print $1}' \
        > /run/nixos-upgrade-before-gen
    '';

    # 成功時のみ実行（postStop → ExecStartPost 相当の仕組みとして
    # nixos-upgrade の postStop を override しつつ成否を自前で判断）
    postStop = lib.mkAfter ''
      export PATH="${lib.makeBinPath [
        pkgs.nix
        pkgs.gawk
        pkgs.coreutils
        pkgs.libnotify
        pkgs.sudo
        pkgs.systemd
      ]}:$PATH"
      # サービスの終了コードを確認（失敗時はスキップ）
      if [ "$SERVICE_RESULT" != "success" ]; then
        echo "Upgrade did not succeed (result: $SERVICE_RESULT). Skipping notification."
        exit 0
      fi

      BEFORE_GEN=$(cat /run/nixos-upgrade-before-gen 2>/dev/null || echo "0")
      LATEST_GEN_INFO=$(nix-env -p /nix/var/nix/profiles/system --list-generations | tail -n 1)
      AFTER_GEN=$(echo "$LATEST_GEN_INFO" | awk '{print $1}')

      rm -f /run/nixos-upgrade-before-gen

      if [ "$BEFORE_GEN" = "$AFTER_GEN" ]; then
        echo "No new generation (still at $BEFORE_GEN). Skipping notification."
        exit 0
      fi

      TARGET_USER="${vars.user.name}"
      USER_ID=$(id -u "$TARGET_USER")

      # machinectl + systemd-run でユーザーセッションに通知（より堅牢）
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
