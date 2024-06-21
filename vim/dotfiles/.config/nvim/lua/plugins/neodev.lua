local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "folke/neodev.nvim",
        enabled = false,
        tag = "v2.5.2",
        opts = {}
    },
    pelyib.config.neodev
)
