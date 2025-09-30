{ config, pkgs, ... }:

{
  imports = [
    ./modules/apps.nix
    ./modules/themes.nix
    #./modules/wm
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Benzenec6h6";
    userEmail = "aconitinec34h47no11@gmail.com";
  };

  # シェル設定例 (zsh を使う場合)
  programs.zsh = {
    enable = true;

    # 補完を有効化
    enableCompletion = true;

    # 履歴管理
    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    # 初期化スクリプト
    initContent = ''
      # 独自 PATH
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      # デフォルトエディタ
      export EDITOR=nvim
      # 必要なら alias もここで定義
      alias ll="ls -la"
    '';
  };
}
