{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y"; # "y" だけで起動

    # 1. 基本的な挙動とGit連携の設定
    settings = {
      manager = {
        show_hidden = true; # 隠しファイル（.config等）を表示
        respect_gitignore = false; # .gitignoreを無視して、すべての中身をプレビュー可能に
        show_git = true; # Gitのステータス変更を追跡
        linemode = "git"; # ファイルの右端にGitステータス(M, A等)を常時表示
        sort_by = "alphabetical";
        ratio = [1 3 4]; # 左カラム:中央:右(プレビュー) の比率
      };
    };

    initLua = ''
      -- git プラグインを初期化して有効化する
      require("git"):setup()
    '';

    # 2. 選別した便利なLuaプラグインの導入
    plugins = {
      # Gitの視認性と操作強化（コア機能）
      git = pkgs.yaziPlugins.git;
      diff = pkgs.yaziPlugins.diff;
      lazygit = pkgs.yaziPlugins.lazygit;

      # 操作性の向上（Vimライクな相対行移動など）
      relative-motions = pkgs.yaziPlugins.relative-motions;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      bookmarks = pkgs.yaziPlugins.bookmarks;

      # ファイルプレビューの強化（Markdown、各種メディア）
      glow = pkgs.yaziPlugins.glow;
      mediainfo = pkgs.yaziPlugins.mediainfo;
      miller = pkgs.yaziPlugins.miller;

      # システムクリップボードとの連携（Wayland環境用）
      wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = ["G"];
          run = "plugin lazygit";
          desc = "Call Lazygit";
        }
      ];
    };

    # 3. プレビューやプラグインの動作に必要なツール群
    extraPackages = with pkgs; [
      ffmpegthumbnailer # 動画用
      imagemagick # 画像用
      poppler # PDF用
      fd # 検索高速化
      ripgrep # 内容検索高速化
      fzf # フィルタリング
      glow # Markdownプレビュー用（プラグインが内部で使用）
      mediainfo # メディア情報取得用（プラグインが内部で使用）
    ];
  };
}
