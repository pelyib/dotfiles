local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "nvim-tree/nvim-web-devicons",
        enabled = false,
        lazy = false,
        commit = "cff25ce621e6d15fae0b0bfe38c00be50ce38468",
    },
    pelyib.config.devicons
)