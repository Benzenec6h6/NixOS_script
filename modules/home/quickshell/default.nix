{pkgs, ...}: {
  programs.quickshell = {
    enable = true;

    # 1. 設定ファイルの配置
    # ~/.config/quickshell/my-shell/ 配下にファイルを配置します
    configs = {
      "my-shell" = ./.;
    };

    # 2. 使用する設定の選択
    # configs で指定したキー名を指定すると、起動時に --config my-shell が付与されます
    activeConfig = "my-shell";

    # 3. systemdによる自動起動
    systemd = {
      enable = true;
      # どのターゲットで起動するか（Hyprlandなら hyprland-session.target など）
      # デフォルトで config.wayland.systemd.target になっているので、
      # HMでHyprland等を使っていれば設定不要な場合が多いです。
    };
  };
}
