local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "jiangmiao/auto-pairs",
        enabled = false,
        tag = "v2.0.0"
    },
    pelyib.config.autopairs
)
