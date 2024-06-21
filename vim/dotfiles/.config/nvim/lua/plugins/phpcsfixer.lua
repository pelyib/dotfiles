local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'stephpy/vim-php-cs-fixer',
        enabled = false,
        commit = "d6dec5d",
    },
    pelyib.config.phpcsfixer
)
