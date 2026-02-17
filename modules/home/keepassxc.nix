{ pkgs, ... }:

{
  # 1. KeePassXC 本体の有効化
  programs.keepassxc = {
    enable = true;
    autostart = true;
  };

  # 2. Git 認証連携の設定 (HTTPS用)
  programs.git-credential-keepassxc.enable = true; 
  #programs.git-credential-keepassxc.groups = [ "Development/GitHub" ];
}