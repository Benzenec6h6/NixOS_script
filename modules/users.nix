{ config, pkgs, ... }:

{
  users.users.me = {
    isNormalUser = true;
    description = "Primary developer user";
    home = "/home/me";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" ];

    # 最低限開発パッケージ
    packages = with pkgs; [
      git
      docker       # CLI
      neovim
      tmux
      qemu
      vscode
    ];
  };

  # sudo 権限
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
