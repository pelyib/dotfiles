local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "stevearc/dressing.nvim",
        enabled = false,
        tag = "v2.1.0",
    },
    pelyib.config.dressing
)
