{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 履歴バッファの設定（10万行あれば十分すぎるほど快適です）
    history = {
      size = 100000;
      save = 100000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # 各種オプションのクリーンアップ
    autocd = true; # ディレクトリ名入力だけで移動
    defaultKeymap = "emacs";

    # --- 1. エイリアス設定（ezaの統合はHome Managerがやるので、追加分だけ） ---
    shellAliases = {
      # nh (Nix Helper) をさらに叩きやすく
      nos = "nh os switch";
      nhb = "nh home switch";
      ncu = "nh os switch --update";

      # 基本のセーフティ
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # 以前の資産（eza --icons や --git は enableZshIntegration が自動で別名を生成しますが、使い慣れた独自名があればここに）
      ll = "eza -lh --icons --git";
      la = "eza -a --icons";
    };

    # --- 2. 純粋なZshスクリプトフック（ツール初期化系はすべて排除） ---
    initContent = ''
      fastfetch
      # 補完メニューの選択を矢印キーで可能に
      zstyle ':completion:*' menu select

      # =====================================================================
      # エンターキー連打で `ls` (eza) と `git status` を自動実行する魔法のフック
      # =====================================================================
      function accept-line-with-magic() {
        if [[ -z "$BUFFER" ]]; then
          echo ""
          # gitリポジトリ内なら git status も同時に出す
          if git rev-parse --is-inside-work-tree &>/dev/null; then
            eza --icons --color=always
            echo ""
            git status -s
          else
            eza --icons --color=always
          fi
          # プロンプトを再描画
          zle reset-prompt
        else
          zle accept-line
        fi
      }
      zle -N accept-line-with-magic
      bindkey '^M' accept-line-with-magic

      if [ -f "/run/secrets/github-token" ]; then
        export GITHUB_TOKEN="$(cat /run/secrets/github-token)"
        export GH_TOKEN="$GITHUB_TOKEN"
      fi
    '';
  };
}
