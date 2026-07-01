{pkgs, ...}: {
  # 1. KeePassXC 本体の有効化
  programs.keepassxc = {
    enable = true;
    autostart = false;
  };

  # 2. Git 認証連携の設定 (HTTPS用)
  programs.git-credential-keepassxc.enable = false;
  #programs.git-credential-keepassxc.groups = [ "Development/GitHub" ];
}
