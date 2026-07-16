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
        ratio = [1 2 5]; # データの視認性を上げるため、プレビュー幅を広げる [1 3 4] から [1 2 5] に変更
      };

      plugin = {
        prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git"; # これが同期に必須です
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        prepend_previewers = [
          {
            url = "*.md";
            run = "code";
          }
          # duckdb.yazi が対応する各種データ拡張子を登録
          {
            url = "*.csv";
            run = "duckdb";
          }
          {
            url = "*.tsv";
            run = "duckdb";
          }
          {
            url = "*.json";
            run = "duckdb";
          }
          {
            url = "*.parquet";
            run = "duckdb";
          }
          {
            url = "*.txt";
            run = "duckdb";
          }
          {
            url = "*.xlsx";
            run = "duckdb";
          }
          {
            url = "*.db";
            run = "duckdb";
          }
          {
            url = "*.duckdb";
            run = "duckdb";
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
        # スムーズなスクロールのための事前キャッシュ読み込み（preload）を設定
        prepend_preloaders = [
          {
            url = "*.csv";
            run = "duckdb";
            multi = false;
          }
          {
            url = "*.tsv";
            run = "duckdb";
            multi = false;
          }
          {
            url = "*.json";
            run = "duckdb";
            multi = false;
          }
          {
            url = "*.parquet";
            run = "duckdb";
            multi = false;
          }
          {
            url = "*.txt";
            run = "duckdb";
            multi = false;
          }
          {
            url = "*.xlsx";
            run = "duckdb";
            multi = false;
          }
        ];
      };
    };

    theme = {
      git = {
        # 色の設定 (Style)
        modified = {fg = "yellow";};
        untracked = {fg = "magenta";};
        added = {fg = "green";};
        deleted = {
          fg = "red";
          bold = true;
        };
        ignored = {fg = "blue";};
        clean = {fg = "green";};

        modified_sign = "M";
        untracked_sign = "?";
        added_sign = "A";
        deleted_sign = "D";
        clean_sign = "✔";
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
      duckdb = {
        package = pkgs.yaziPlugins.duckdb;
        setup = true;
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
          # ─── duckdb 用のキーマップ ───
          {
            on = ["H"];
            run = "plugin duckdb -1";
            desc = "Scroll one column to the left";
          }
          {
            on = ["L"];
            run = "plugin duckdb +1";
            desc = "Scroll one column to the right";
          }
          {
            on = ["g" "o"];
            run = "plugin duckdb -open";
            desc = "open with duckdb";
          }
          {
            on = ["g" "u"];
            run = "plugin duckdb -ui";
            desc = "open with duckdb ui";
          }
        ]
        ++ (map (n: {
          on = [(toString n)];
          run = "plugin relative-motions --args=${toString n}";
          desc = "Move in relative steps";
        }) [1 2 3 4 5 6 7 8 9]);
    };

    # 4. init.lua への追加記述
    # plugins.*.setup = true の場合、Home Managerが自動で `require("duckdb"):setup()` を生成しますが、
    # オプション（モードやキャッシュサイズ等）をカスタムしたい場合は、ここに以下のように記述できます。
    initLua = ''
      -- 必要に応じてカスタム設定を行う場合（現状はデフォルト動作になります）
      -- require("duckdb"):setup({ mode = "summarized", cache_size = 500 })
    '';

    # 5. 必要なバイナリの導入
    extraPackages = with pkgs; [
      lazygit
      wl-clipboard
      glow
      mediainfo
      duckdb
      fd
      ripgrep
      fzf
      ffmpegthumbnailer
      imagemagick
      poppler
    ];
  };
}
