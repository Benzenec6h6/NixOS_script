-- ========================================================================== --
-- 1. 基本設定 (Leaderキー)
-- ========================================================================== --
vim.g.mapleader = " " -- スペースキーを起点にする

-- ========================================================================== --
-- 2. キーマッピング
-- ========================================================================== --
local key = vim.keymap.set

-- 【移動】バッファを切り替える (マウスを使わない代わりの命綱)
key('n', 'L', ':bnext<CR>', { silent = true })     -- 次のファイルへ
key('n', 'H', ':bprevious<CR>', { silent = true }) -- 前のファイルへ

-- 【整理】不要なバッファを閉じる
key('n', '<leader>q', ':bdelete<CR>', { silent = true })

-- 【検索】Telescope (Space + f + ...)
local ts = require('telescope.builtin')
key('n', '<leader>ff', ts.find_files, {}) -- ファイル名検索
key('n', '<leader>fg', ts.live_grep, {})  -- 全文検索
key('n', '<leader>fb', ts.buffers, {})    -- 開いているバッファ一覧

-- 【UI】nvim-tree (Ctrl + n または Space + e)
key('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
key('n', '<leader>e', ':NvimTreeFocus<CR>', { silent = true })

-- 【検索ハイライト】Esc 2回で検索の光を消す
key('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true })

-- ========================================================================== --
-- 3. プラグイン設定
-- ========================================================================== --

-- Gitsigns (差分表示)
require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
})

-- nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = false },
})

-- Lualine (下のバー)
require('lualine').setup()

-- Which-key (操作ガイド)
require("which-key").setup()

-- ========================================================================== --
-- 4. LSP設定 (nixd & lua_ls)
-- ========================================================================== --
-- LSPをNeovimの機能に紐付ける設定 (lspconfig が入っている前提)
-- pluginsに nvim-lspconfig を追加しておくことを推奨します
local lspconfig = require('lspconfig')

-- Nix (nixd)
lspconfig.nixd.setup{}

-- Lua (lua_ls)
lspconfig.lua_ls.setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}, -- vim というグローバル変数をエラーにしない
      },
    },
  },
}

-- ========================================================================== --
-- 5. オートコマンド (IME制御)
-- ========================================================================== --
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
      local cmd = vim.g.fcitx5_remote_path or "fcitx5-remote"
      local handle = io.popen(cmd .. " -c")
      if handle then handle:close() end
  end,
})