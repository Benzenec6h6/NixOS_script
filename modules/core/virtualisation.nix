{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm; # GUI等フル機能版のQEMU
      runAsRoot = false;
      swtpm.enable = true;      # TPMエミュレータを有効化
      verbatimConfig = ''
        namespaces = []
      '';
    };
  };
  
  services.tuned = {
    enable = true;
    # 基本的な設定
    settings.dynamic_tuning = true;
  };
}
