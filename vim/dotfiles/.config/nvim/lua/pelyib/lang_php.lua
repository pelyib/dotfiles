local M = {}

M.setup = function ()
    --[[
    TODO: Read the word under the cursor and call a 3rd party app with it
    function Run_test()
    vim.api.nvim_echo('vim.fn.expand "<cword>"', false, {})
    end
    vim.keymap.set('n', '<leader>prt', '<cmd>lua Run_test()<cr>');
    --]]
    function PhpactorCreateNewObj()
        local isInterface = vim.fn.stridx(vim.fn.expand('%'), 'Interface') 
        vim.api.nvim_call_function(
        'phpactor#rpc',
        { 'class_new', { current_path = vim.api.nvim_call_function('phpactor#_path', {}), variant = "default" } }
        )
    end

    function PhpactorImplementContract()
        vim.api.nvim_call_function(
        'phpactor#rpc',
        {
            'transform',
            {
                transform = 'implement_contracts',
                source = vim.api.nvim_call_function('phpactor#_source', {}),
                path = vim.api.nvim_call_function('phpactor#_path', {})
            }
        }
        )
    end

    vim.keymap.set('n', '<leader>pn', '<cmd>lua PhpactorCreateNewObj()<cr>')
    vim.keymap.set('n', '<leader>pi', '<cmd>lua PhpactorImplementContract()<cr>')
end

return M
