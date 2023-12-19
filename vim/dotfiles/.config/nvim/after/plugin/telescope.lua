local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
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
