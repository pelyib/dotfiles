local M = {
    gitui = nil
}

M.setup = function ()
    local Terminal = require('toggleterm.terminal').Terminal
    M.gitui = Terminal:new({cmd = "gitui", hidden = true})

    vim.api.nvim_create_user_command('Gituitoggle', function ()
        M.gitui:toggle()
    end, {})
    vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>')
    vim.keymap.set('n', '<leader>git', '<cmd>Gituitoggle<cr>', {noremap = true, silent = true})
end

return M
