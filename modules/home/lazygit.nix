{
  config,
  pkgs,
  ...
}: {
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true; # zsh用のエイリアスや統合を有効化

    settings = {
      # 必要に応じてlazygit自体のカスタム設定（テーマや挙動）をここに書けます
      gui = {
        theme = {
          lightTheme = false;
        };
      };
    };
  };
}
