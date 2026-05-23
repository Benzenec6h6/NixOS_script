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
key('n', '<leader>oc', ':OrgCapture<CR>', { silent = true })  -- キャプチャ起動

-- CodeCompanion
key({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
key({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true })
key("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- ========================================================================== --
-- 3. プラグイン設定
-- ========================================================================== --

-- Gitsigns (差分表示)
require('gitsigns').setup()

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
vim.g["conjure#log#direction"] = "vertical"
vim.g["conjure#log#size"] = 0.3

-- ========================================================================== --
-- 4. LSP設定 (nixd & lua_ls)
-- ========================================================================== --
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local servers = {
  racket_langserver = {},
  nixd = {},
  bashls = {},
  basedpyright = {},
  hls = {},
  ts_ls = {},
  elixir_ls = {},
  lua_ls = {
    settings = {
      Lua = { diagnostics = { globals = { 'vim' } } }
    },
  },
}

local bin_map = {
  lua_ls = 'lua-language-server',
  hls = 'haskell-language-server-wrapper',
  bashls = 'bash-language-server',
  ts_ls = 'typescript-language-server',
  elixir_ls = 'elixir-ls'
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for lsp, config in pairs(servers) do
  local bin = bin_map[lsp] or lsp
  if vim.fn.executable(bin) == 1 then
    config.capabilities = capabilities
    -- 重要: ts_lsやbasedpyrightのLSPフォーマッタが重複起動して衝突するのを防ぐ
    config.on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    if next(config) ~= nil then
      vim.lsp.config(lsp, config)
    end
    vim.lsp.enable(lsp)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    key('n', 'gd', vim.lsp.buf.definition, opts)
    key('n', 'K', vim.lsp.buf.hover, opts)
    key('n', '<leader>rn', vim.lsp.buf.rename, opts)
    key('n', 'gl', vim.diagnostic.open_float, opts)
    key('n', '[d', vim.diagnostic.goto_prev, opts)
    key('n', ']d', vim.diagnostic.goto_next, opts)
  end,
})

-- ========================================================================== --
-- 4.5. Conform.nvim 設定（コード規約フォーマッタの一元管理）
-- ========================================================================== --
require("conform").setup({
  formatters_by_ft = {
    -- 言語ごとに、適用したいツールを順番に割り当てます
    python = { "ruff_format" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    typescriptreact = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    nix = { "alejandra" },
    -- ElixirはLSP内蔵ではなくプロジェクトの.formatter.exsに従うmixを実行可能
    elixir = { "mix" },
    heex = { "mix" },
  },
  -- 保存時の自動フォーマットに関する詳細設定
  format_on_save = {
    timeout_ms = 500,        -- 0.5秒以内に終わらない場合はバックグラウンド処理
    lsp_format = "fallback", -- conformに指定がない言語はLSPフォーマットを試みる
  },
})

-- ========================================================================== --
-- 5. オートコマンド (IME制御 / 自動フォーマット)
-- ========================================================================== --
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    local cmd = vim.g.fcitx5_remote_path or "fcitx5-remote"
    local handle = io.popen(cmd .. " -c")
    if handle then handle:close() end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- ========================================================================== --
-- 6. Orgmode / Otter
-- ========================================================================== --
require('orgmode').setup({
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
      org_toggle_checkbox = '<leader>x',
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
-- 7. 補完(cmp) / 編集補助
-- ========================================================================== --
require("ibl").setup()
require("nvim-surround").setup()
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
    { name = 'orgmode' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- 画像 / Markdown 表示
require("image").setup({
  backend = vim.g.terminal_image_backend,
  integrations = {
    markdown = {
      enabled = true,
      filetypes = { "markdown", "vimwiki", "org" },
    },
  },
})
require('render-markdown').setup({
  file_types = { "markdown", "codecompanion" },
})

-- ========================================================================== --
-- 8. AI 連携 (CodeCompanion)
-- ========================================================================== --
require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "gemini",
      slash_commands = {
        ["search"] = {
          callback = "strategies.chat.slash_commands.mcp",
          opts = {
            adapter = "gemini",
            command = "npx",
            -- OpenWebSearch へ変更
            args = { "-y", "@Aas-ee/open-websearch" },
            -- APIキー不要のため env は空
            env = {},
          },
        },
      },
    },
    inline = { adapter = "ollama" },
    agent = { adapter = "ollama" },
  },
  adapters = {
    http = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = { api_key = vim.env.GEMINI_API_KEY },
        })
      end,
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          env = { url = "http://127.0.0.1:11434" },
          schema = {
            model = { default = "qwen2.5:7b" },
            num_ctx = { default = 8192 },
          },
        })
      end,
    },
  },
})
vim.cmd([[cabbrev cc CodeCompanion]])
