local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        tag = "0.7.0",
    },
    pelyib.config.dap
)