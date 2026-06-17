{
  config,
  pkgs,
  inputs,
  vars,
  ...
}: let
  # inputsからRustツールを取得
  rust-tools-pkg = inputs.rust-tools.packages.${vars.system}.default;
in {
  # 1. システム全体にバイナリをインストール（任意ですが、ターミナルからも叩けて便利です）
  environment.systemPackages = [rust-tools-pkg];

  # 2. systemd サービス定義 (テンプレートサービス)
  systemd.services."storage-monitor@" = {
    description = "Storage monitor notification for %i";
    serviceConfig = {
      Type = "oneshot";
      # フルパスで実行することで、確実にflakeのバイナリを叩く
      ExecStart = "${rust-tools-pkg}/bin/storage-monitor %i";
    };
  };

  # 3. udev ルール
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ATTR{removable}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="storage-monitor@%k.service"
  '';

  # 4. sudo-rs の設定 (storage-monitor内部でsudo -uを使うため)
  security.sudo-rs.extraConfig = ''
    # rootが一般ユーザーとしてnotify-sendを実行することを許可
    root ALL=(ALL) NOPASSWD: ${pkgs.libnotify}/bin/notify-send
  '';
}
