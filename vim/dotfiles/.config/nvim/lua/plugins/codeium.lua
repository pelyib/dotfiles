local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'Exafunction/codeium.vim',
        tag = "1.8.62",
        enabled = false,
    },
    pelyib.config.codeium
)
