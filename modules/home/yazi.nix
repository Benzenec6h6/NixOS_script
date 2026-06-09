{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y"; # "y" だけで起動

    # 1. 基本的な挙動とGit連携の設定
    settings = {
      manager = {
        show_hidden = true; # 隠しファイルを表示
        respect_gitignore = false; # .gitignoreを無視してプレビュー可能に
        show_git = true; # Gitのステータス変更を追跡
        linemode = "git"; # ファイルの右端にGitステータスを表示
        sort_by = "alphabetical";
        ratio = [1 3 4]; # スペースを空けてNixの正しいリスト形式に修正
      };
    };

    # 2. ソースコードの仕様に完全に適合させたプラグイン設定
    plugins = {
      # setup = true にすることで、Home-managerが自動で require("git"):setup() を生成します
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };
      diff = {
        package = pkgs.yaziPlugins.diff;
        setup = true;
      };
      lazygit = {
        package = pkgs.yaziPlugins.lazygit;
        setup = true;
      };

      relative-motions = {
        package = pkgs.yaziPlugins.relative-motions;
        setup = true;
      };
      smart-enter = {
        package = pkgs.yaziPlugins.smart-enter;
        setup = true;
      };
      bookmarks = {
        package = pkgs.yaziPlugins.bookmarks;
        setup = true;
      };

      glow = {
        package = pkgs.yaziPlugins.glow;
        setup = true;
      };
      mediainfo = {
        package = pkgs.yaziPlugins.mediainfo;
        setup = true;
      };
      miller = {
        package = pkgs.yaziPlugins.miller;
        setup = true;
      };
      wl-clipboard = {
        package = pkgs.yaziPlugins.wl-clipboard;
        setup = true;
      };
    };

    # 3. キーバインドの修正（Gの衝突を回避）
    keymap = {
      manager.prepend_keymap = [
        {
          on = ["g" "l"]; # 大文字 'G' 単体から、'g' -> 'l' の複合キーに変更
          run = "plugin lazygit";
          desc = "Call Lazygit";
        }
      ];
    };

    # 4. プレビューやプラグインの動作に必要なツール群
    extraPackages = with pkgs; [
      lazygit
      wl-clipboard
      ffmpegthumbnailer
      imagemagick
      poppler
      fd
      ripgrep
      fzf
      glow
      mediainfo
    ];
  };
}
