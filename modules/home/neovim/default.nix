{ config, pkgs, vars, ... }:
let
  # ターミナルに応じた image.nvim のバックエンドを決定
  image_backend = if vars.user.terminal == "kitty" then "kitty" 
                  else if vars.user.terminal == "ghostty" then "iterm2" 
                  else "ueberzug"; # フォールバック
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # --- UI / 情報表示 ---
      lualine-nvim          # 下部のステータスライン
      nvim-web-devicons     # 各種アイコン表示用
      image-nvim            #画像の表示
      gitsigns-nvim         # [解決済] 行番号横の差分表示
      nvim-lspconfig        #lsp設定を動かす

      # --- 補完 / スニペット ---
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip 
      cmp_luasnip
      indent-blankline-nvim
      nvim-surround
      
      # --- ファイル管理・検索 ---
      nvim-tree-lua         # サイドバー (C-n)
      telescope-nvim        # [重要] あらゆる検索の窓口
      telescope-fzf-native-nvim
      plenary-nvim          # telescope等の動作に必須
      yazi-nvim             # ファイルマネージャーyaziとの連携

      # --- Lisp / Racket 開発環境 ---
      conjure               # [重要] REPL駆動開発の核心
      vim-racket            # Racket用のインデント・構文定義
      parinfer-rust         # 括弧の自動管理 (任意ですが超強力です)

      # --- 構文解析・編集補助 ---
      (nvim-treesitter.withPlugins (p: with p; [
        nix lua vim vimdoc bash racket
        json yaml toml
        markdown markdown_inline
        html css javascript typescript python haskell
      ]))

      # --- 特定のワークフロー ---
      orgmode          # メモ・タスク管理
      otter-nvim
      pkgs.tree-sitter-grammars.tree-sitter-org-nvim
      toggleterm-nvim       # Neovim内で端末を浮遊表示

      # --- [提案] 操作を覚えるための補助 ---
      which-key-nvim        # Spaceを押した時にガイドを出す (ストイック期の味方)
    ];

    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set shiftwidth=2
      set tabstop=2
      set smartindent
      set clipboard=unnamedplus
      set mouse=a
    '';

    extraLuaConfig = ''
      vim.g.terminal_image_backend = "${image_backend}"
      vim.g.fcitx5_remote_path = "${pkgs.fcitx5}/bin/fcitx5-remote"
      ${builtins.readFile ./init.lua}
    '';
  };
}
