local M = {}

M.setup = function ()
    vim.keymap.set('n', 'zo', '<cmd>foldopen<cr>')
    vim.keymap.set('n', 'zc', '<cmd>foldclose<cr>')
    local ufo = require('ufo')
    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)
end

return M
