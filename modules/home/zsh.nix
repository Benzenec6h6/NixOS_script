{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # 補完候補をキャッシュして高速化
    completionInit = ''
      autoload -Uz compinit
      compinit -d ~/.cache/zcompdump
    '';

    # Zsh プラグイン
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
      }
    ];

    # 起動時に fastfetch を表示 + fzf, zoxide, eza, bat の統合設定
    initContent = ''
      fastfetch

      # fzf 設定（インクリメンタル検索）
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
      export FZF_CTRL_T_COMMAND="eza --all --color=always"
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"

      # bat を less の代替に設定（シンタックス付き cat）
      export PAGER="less -R"
      alias cat="bat --paging=never"

      # eza を ls の代替に設定（ツリー表示・色付き）
      alias ls="eza --icons --color=always --group-directories-first"
      alias ll="eza -lh --icons --git"
      alias la="eza -lha --icons --git"
      alias lt="eza -T --icons"

      # zoxide 設定（ディレクトリ履歴ジャンプ）
      eval "$(zoxide init zsh)"
      alias cd="z"

      # fzf + zoxide 連携（インタラクティブなディレクトリ移動）
      fzf_cd() {
        local dir
        dir=$(zoxide query -l | fzf --prompt='Jump to dir> ') && cd "$dir"
      }
      alias cdf="fzf_cd"

      if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
      fi
    '';
  };
}