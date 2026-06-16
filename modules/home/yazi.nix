{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    # 1. yazi.toml の設定
    settings = {
      mgr = {
        show_hidden = true;
        respect_gitignore = false;
        show_git = true;
        linemode = "git";
        sort_by = "alphabetical";
        ratio = [1 3 4];
      };

      plugin = {
        prepend_previewers = [
          {
            url = "*.md";
            run = "code";
          }
          {
            url = "*.csv";
            run = ''shell -- "mlr --icsv --opprint -g color cat \"$1\"" '';
          }
          {
            url = "*.diff";
            run = "diff";
          }
          {
            mime = "audio/*";
            run = "mediainfo";
          }
          {
            mime = "video/*";
            run = "mediainfo";
          }
        ];
      };
    };

    theme = {
      git = {
        # 1. 一度コミットした後に内容を編集したファイル（Modified）
        # Draculaの鮮やかなイエロー/オレンジを指定して、埋もれないようにします
        modified = {fg = "yellow";};

        # 2. まだ一度もコミット・追跡されていない完全な新規ファイル（Untracked）
        # 今まで通り、目立つピンク/レッドで警告します
        untracked = {fg = "magenta";}; # もしくは "red"

        # 3. git add してコミットを待っている状態（Staged）
        # 綺麗なグリーンに変化させて安心感を演出します
        staged = {fg = "green";};

        # その他、リネームや削除
        renamed = {fg = "cyan";};
        deleted = {fg = "red";};
      };
    };

    # 2. プラグインの定義
    plugins = {
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };
      lazygit = {
        package = pkgs.yaziPlugins.lazygit;
        setup = false;
      };
      bookmarks = {
        package = pkgs.yaziPlugins.bookmarks;
        setup = false;
      };

      # ハイフンを含むプラグイン名は、Nixの文字列クォートで囲むと安全です
      "relative-motions" = {
        package = pkgs.yaziPlugins.relative-motions;
        setup = true;
      };
      "smart-enter" = {
        package = pkgs.yaziPlugins.smart-enter;
        setup = false;
      };

      # 呼ぶべき setup() を持たないプレビュー・機能系プラグインは setup = false に
      diff = {
        package = pkgs.yaziPlugins.diff;
        setup = false;
      };
      glow = {
        package = pkgs.yaziPlugins.glow;
        setup = false;
      };
      mediainfo = {
        package = pkgs.yaziPlugins.mediainfo;
        setup = false;
      };
      miller = {
        package = pkgs.yaziPlugins.miller;
        setup = false;
      };
      "wl-clipboard" = {
        package = pkgs.yaziPlugins.wl-clipboard;
        setup = false;
      };
    };

    # 3. keymap.toml の設定
    keymap = {
      mgr.prepend_keymap =
        [
          {
            on = ["l"];
            run = "plugin smart-enter";
            desc = "Enter directory or open file";
          }
          {
            on = ["g" "l"];
            run = "plugin lazygit";
            desc = "Call Lazygit";
          }
          {
            on = ["y"];
            run = "plugin wl-clipboard";
            desc = "Copy to system clipboard";
          }
          {
            on = ["m"];
            run = "plugin bookmarks --args=save";
            desc = "Save bookmark";
          }
          {
            on = ["'"];
            run = "plugin bookmarks --args=jump";
            desc = "Jump to bookmark";
          }
          {
            on = ["d" "f"];
            run = "plugin diff";
            desc = "Diff selected files";
          }
        ]
        ++ (map (n: {
          on = [(toString n)];
          run = "plugin relative-motions --args=${toString n}";
          desc = "Move in relative steps";
        }) [1 2 3 4 5 6 7 8 9]);
    };

    # 4. init.lua への追加記述 (UI調整など)
    initLua = ''
      -- ステータスバーにGit情報を表示する設定（型安全な結合に修正）
      Status:children_add(function()
          local h = cx.active.current.hovered
          if h == nil or h.git == nil then return "" end
          return " (" .. tostring(h.git) .. ")"
      end, 500, Status.RIGHT)
    '';

    # 5. 必要なバイナリの導入
    extraPackages = with pkgs; [
      lazygit
      wl-clipboard
      glow
      mediainfo
      miller
      fd
      ripgrep
      fzf
      ffmpegthumbnailer
      imagemagick
      poppler
    ];
  };
}
