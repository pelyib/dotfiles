local pluginconf = require("pelyib.pluginconf").config.patched

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
    pluginconf.gitblame or {}
)
