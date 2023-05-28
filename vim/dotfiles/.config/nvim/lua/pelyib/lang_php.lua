local M = {}

M.setup = function ()
--[[
TODO: Read the word under the cursor and call a 3rd party app with it
function Run_test()
vim.api.nvim_echo('vim.fn.expand "<cword>"', false, {})
end
vim.keymap.set('n', '<leader>prt', '<cmd>lua Run_test()<cr>');
--]]
end

return M
