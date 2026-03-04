-- 挿入モードを抜ける時にIMEをオフにする (Fcitx5用)
-- 1 = オフ, 2 = オン
vim.api.nvim_create_autocmd("InsertLeave", {
pattern = "*",
callback = function()
    local cmd = vim.g.fcitx5_remote_path or "fcitx5-remote"
    local handle = io.popen(cmd .. " -c")
    if handle then handle:close() end
end,
})

-- nvim-treeの初期化
require("nvim-tree").setup({
sort_by = "case_sensitive",
view = {
    width = 30,
},
renderer = {
    group_empty = true,
},
filters = {
    dotfiles = false,
},
})

-- キーマッピング (例: Ctrl+n でツリーを開閉)
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })