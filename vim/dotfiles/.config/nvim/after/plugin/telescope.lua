local success, builtin = pcall(require, "telescope.builtin")
if success == false then
    return
end

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set("n", "<leader>fga", function () require('telescope').extensions.live_grep_args.live_grep_args() end )

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
vim.keymap.set('n', '<leader>fGa', live_grep_args_shortcuts.grep_word_under_cursor )
vim.keymap.set('n', '<leader>fG', function () builtin.live_grep({ default_text = vim.fn.expand('<cword>')}) end)
vim.keymap.set('v', '<leader>fg', function ()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    local default_text = ''
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        default_text = text
    end

    builtin.live_grep({ default_text = default_text })
end, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>gh', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gfh', builtin.git_bcommits, {})

vim.keymap.set('n', 'gic', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

vim.keymap.set('n', 'cp', '<cmd>Telescope neoclip<cr>')
vim.keymap.set('n', 'ar', '<cmd>Telescope aerial<cr>')
vim.keymap.set('n', 'gn', function () require('telescope').extensions.notify.notify() end)
