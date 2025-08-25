{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  # zsh
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
    initExtra = ''
      # 独自 PATH
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      # デフォルトエディタ
      export EDITOR=nvim
      # 必要なら alias もここで定義
      alias ll="ls -la"
    '';
  };
  # starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  home.packages = with pkgs; [
    # Terminal / Utilities
    alacritty foot wezterm tmux starship htop btop nvtopPackages.nvidia fzf ripgrep unzip unrar p7zip

    # Browsers / GUI apps
    firefox chromium vscode discord qbittorrent steam

    # Wine
    wineWowPackages.full winetricks

    # Dotfile management
    stow git
  ];

  programs.git = {
    enable = true;
    userName  = "Benzenec6h6";
    userEmail = "aconitinec34h47no11@gmail.com";
  };

  # Xsession を有効化して WM を管理
  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      keybindings = {
        "Mod4+Return" = "alacritty";
        "Mod4+d" = "dmenu_run";
        "Mod4+Shift+q" = "i3-msg kill";
      };
    };
  };
}
