{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    # パッケージの指定が必要な場合は追加（nixpkgsのバージョンによります）
    # package = pkgs.ghostty; 

    settings = {
      # Stylixの色設定を反映
      background = "${config.lib.stylix.colors.base00}";
      foreground = "${config.lib.stylix.colors.base05}";
      cursor-color = "${config.lib.stylix.colors.base05}";
      palette = [
        "0=#${config.lib.stylix.colors.base01}"
        "1=#${config.lib.stylix.colors.base08}"
      ];

      # フォント設定
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;

      # ウィンドウ装飾と挙動
      window-decoration = false;
      confirm-close-surface = false;
      copy-on-select = true;

      # スクロールバック
      scrollback-limit = 10000;

      keybind = [
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab"
      ];
    };
  };

  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=ghostty
  '';
}
