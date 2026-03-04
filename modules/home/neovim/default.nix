{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. プラグインの追加
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      nvim-web-devicons # アイコンを表示するために推奨
      (nvim-treesitter.withPlugins (p: with p; [
        # 必須・基本
        nix
        lua
        vim
        vimdoc
        query # Treesitter自体のデバッグ用

        # Web / 設定ファイル (よく遭遇するもの)
        html
        css
        javascript
        typescript
        json
        yaml
        toml
        markdown
        markdown_inline

        # 自分がいつか書くかもしれない言語 (お好みで)
        python
        bash
        rust
        go
        dockerfile
      ]))
    ];

    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set shiftwidth=2
      set tabstop=2
      set smartindent
      set clipboard=unnamedplus
    '';

    # 2. Luaによるプラグインの設定
    extraLuaConfig = ''
      vim.g.fcitx5_remote_path = "${pkgs.fcitx5}/bin/fcitx5-remote"
      ${builtins.readFile ./init.lua}
    '';
  };
}