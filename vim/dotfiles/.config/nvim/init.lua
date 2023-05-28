require('pelyib').setup()

vim.cmd([[colorscheme everforest]])

vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<cr>', {})

vim.keymap.set('n', 'zo', '<cmd>foldopen<cr>')
vim.keymap.set('n', 'zc', '<cmd>foldclose<cr>')
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

vim.keymap.set('n', 'cp', '<cmd>Telescope neoclip<cr>')
