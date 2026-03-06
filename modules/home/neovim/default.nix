{ config, pkgs, ... }:

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
      gitsigns-nvim         # [解決済] 行番号横の差分表示
      nvim-lspconfig        #lsp設定を動かす
      
      # --- ファイル管理・検索 ---
      nvim-tree-lua         # サイドバー (C-n)
      telescope-nvim        # [重要] あらゆる検索の窓口
      plenary-nvim          # telescope等の動作に必須
      yazi-nvim             # ファイルマネージャーyaziとの連携

      # --- 構文解析・編集補助 ---
      (nvim-treesitter.withPlugins (p: with p; [
        nix lua vim vimdoc bash
        json yaml toml
        markdown markdown_inline
      ]))

      # --- 特定のワークフロー ---
      orgmode          # メモ・タスク管理
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
      vim.g.fcitx5_remote_path = "${pkgs.fcitx5}/bin/fcitx5-remote"
      ${builtins.readFile ./init.lua}
    '';
  };
}