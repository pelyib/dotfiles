local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'Exafunction/codeium.nvim',
        enabled = false,
        commit = "d3b88eb3aa1de6da33d325c196b8a41da2bcc825",
        config = function()
            require("codeium").setup({
            })
        end
    },
    pelyib.config.codeium
)
