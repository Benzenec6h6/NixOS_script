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

-- Orgmode用のキーバインドをリーダーキー配下に追加
key('n', '<leader>oa', ':OrgAgendaUI<CR>', { silent = true }) -- アジェンダ表示
key('n', '<leader>oc', ':OrgCapture<CR>', { silent = true })  -- キャプチャ起動（j, i, tを選択）

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

-- Conjureの設定
-- ログ（評価結果）を右側に縦分割で表示する設定
vim.g["conjure#log#direction"] = "vertical"
vim.g["conjure#log#size"] = 0.3 -- 画面の30%を使用

-- ========================================================================== --
-- 4. LSP設定 (nixd & lua_ls)
-- ========================================================================== --
-- 診断表示のカスタマイズ
vim.diagnostic.config({
  virtual_text = true,      -- 行末にうっすらエラーを出す
  signs = true,             -- 行番号の左側にアイコンを出す
  underline = true,         -- エラー箇所に下線を引く
  update_in_insert = false, -- 入力中はうるさくないように更新しない
  severity_sort = true,     -- 重大なエラーを優先して表示
})

local servers = {
  racket_langserver = {},
  nixd = {},
  bashls = {},
  basedpyright = {},
  hls = {},
  lua_ls = {
    settings = {
      Lua = { diagnostics = { globals = { 'vim' } } }
    },
  },
}

-- バイナリ名のマッピング (実行ファイル名がLSP名と異なる場合)
local bin_map = {
  lua_ls = 'lua-language-server',
  hls = 'haskell-language-server-wrapper',
  bashls = 'bash-language-server',
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for lsp, config in pairs(servers) do
  local bin = bin_map[lsp] or lsp

  if vim.fn.executable(bin) == 1 then
    -- 新しい設定方式: vim.lsp.config を使用 (v0.11+)
    -- もし lspconfig の拡張機能が必要な場合は、ここを vim.lsp.config(lsp, config) にします
    config.capabilities = capabilities
    vim.lsp.enable(lsp)

    -- 特殊な設定（lua_ls の globals など）がある場合は config を渡す
    if next(config) ~= nil then
      vim.lsp.config(lsp, config)
    end
  end
end

-- LSPが起動した時の共通キーマッピング
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    key('n', 'gd', vim.lsp.buf.definition, opts)
    key('n', 'K', vim.lsp.buf.hover, opts)
    key('n', '<leader>rn', vim.lsp.buf.rename, opts)

    -- 'gl' (Go Line diagnostics) で浮動ウィンドウにエラー理由を表示
    key('n', 'gl', vim.diagnostic.open_float, opts)
    -- '[d' や ']d' でエラー箇所を飛び回る
    key('n', '[d', vim.diagnostic.goto_prev, opts)
    key('n', ']d', vim.diagnostic.goto_next, opts)
  end,
})

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

-- ========================================================================== --
-- 6. オートフォーマット (保存時に実行)
-- ========================================================================== --
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- LSPに整列を依頼する
    -- (フォーマッタがPATHに存在し、LSPがそれに対応している場合のみ動作)
    vim.lsp.buf.format({ async = false })
  end,
})

require('orgmode').setup({
  -- あなたのTODOファイルの場所を指定（例：ホームディレクトリのorgフォルダ内すべて）
  org_agenda_files = { '~/Documents/org/**/*' },
  org_default_notes_file = '~/Documents/org/refile.org',
  org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'STARTED(s)', 'WAITING(w)', '|', 'DONE(d)' },
  org_capture_templates = {
    j = { description = 'Job (営業・案件)', template = '* NEXT %?\n  SCHEDULED: %t' },
    i = { description = 'Invest (投資・分析)', template = '* TODO %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:' },
    t = { description = 'Tech (技術検証)', template = '* TODO %?\n  :PROPERTIES:\n  :TAGS: :Research:\n  :END:' },
  },
  mappings = {
    org = {
      org_toggle_checkbox = '<leader>x', -- Space + x でチェック！
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "org",
  callback = function()
    require 'otter'.activate({ "nix", "lua", "bash" })
  end
})

-- ========================================================================== --
-- 補完(cmp)の設定
-- ========================================================================== --
-- indent-blankline (インデントの視覚化)
require("ibl").setup()
-- nvim-surround (文字の囲み操作)
require("nvim-surround").setup()
-- telescope-fzf-native のロード
require('telescope').load_extension('fzf')

local cmp = require('cmp')
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'conjure' },
    { name = 'orgmode' }, -- Orgmodeのタグなども補完対象に
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- 画像の表示
require("image").setup({
  backend = vim.g.terminal_image_backend,
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki", "org" }, -- orgも追加しておくと便利です
    },
  },
  max_width = 100,
  max_height = 12,
  window_overlap_clear_enabled = true, -- ウィンドウが重なった時に画像を消す
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})

-- ========================================================================== --
-- AI 連携 (Avante.nvim)
-- ========================================================================== --
require('avante_lib').load()
require('avante').setup({
  provider = "ollama",
  providers = {
    ollama = {
      ["local"] = true,
      endpoint = "127.0.0.1:11434/v1",
      model = "deepseek-coder-v2:16b",
      parse_curl_args = function(opts, code_opts)
        return {
          url = opts.endpoint .. "/chat/completions",
          headers = {
            ["Accept"] = "application/json",
            ["Content-Type"] = "application/json",
          },
          body = vim.tbl_deep_extend("force", {
            model = opts.model,
            messages = code_opts.messages,
            stream = true,
          }, opts.options),
        }
      end,
      parse_response_data = function(data_stream, event_state, opts)
        require("avante.providers").openai.parse_response_data(data_stream, event_state, opts)
      end,
    },
  },
})

-- render-markdown (AIの回答やドキュメントを読みやすくする)
require('render-markdown').setup({
  file_types = { "markdown", "Avante" },
})
