return {
    'stephpy/vim-php-cs-fixer',
    commit = "d6dec5d",
    config = function ()
        function PhpCsFixerFixAll()
            vim.api.nvim_call_function('PhpCsFixerFixFile', {})
        end
        vim.keymap.set('n', 'csf', '<cmd>lua PhpCsFixerFixAll()<cr>')
        vim.g.php_cs_fixer_allow_risky = 'yes'
    end
}
