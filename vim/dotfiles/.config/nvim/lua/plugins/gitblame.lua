local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'f-person/git-blame.nvim',
        enabled = false,
        commit = "f07e913",
        config = function ()
            require("gitblame").setup({
                enabled = false,
            })
        end
    },
    pelyib.config.gitblame
)
