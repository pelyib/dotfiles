local M = {}

M.setup = function ()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>gh', builtin.git_commits, {})
    vim.keymap.set('n', '<leader>gfh', builtin.git_bcommits, {})

    vim.keymap.set('n', 'gic', builtin.lsp_incoming_calls, {})
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

    vim.keymap.set('n', 'cp', '<cmd>Telescope neoclip<cr>')
end

return M
