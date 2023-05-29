local M = {}

M.setup = function ()
    vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<cr>', {})
end

return M
