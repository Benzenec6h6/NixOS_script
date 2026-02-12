{ pkgs, lib, ... }:

{
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "com.github.tchx84.Flatseal"
      "io.github.dvlv.boxbuddyrs"
    ];
    update.onActivation = true;
  };

  # nix-flatpak が生成するサービスの設定を補強
  systemd.services.flatpak-managed-install = {
    # ネットワークが完全にオンラインになるのを待つ
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      # 失敗しても10秒おきにリトライ（これでリビルドエラーを防ぐ）
      Restart = lib.mkForce "on-failure";
      RestartSec = lib.mkForce "10s";
    };
  };
}