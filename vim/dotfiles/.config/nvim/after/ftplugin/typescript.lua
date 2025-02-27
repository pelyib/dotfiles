vim.keymap.set('n', 'csf', function ()
    vim.api.nvim_call_function('EslintFixAll', {})
end)
