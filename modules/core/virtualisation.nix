{ pkgs, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_full; # GUI等フル機能版のQEMU
      swtpm.enable = true;      # TPMエミュレータを有効化
      verbatimConfig = ''
        user = "teto"  # あなたのUID 1000のユーザー名
        group = "libvirtd"
      '';
    };
  };

  services.tuned = {
    enable = true;
    # 基本的な設定
    settings.dynamic_tuning = true;
  };
}
