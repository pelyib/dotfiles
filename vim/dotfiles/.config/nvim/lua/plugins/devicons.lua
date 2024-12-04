local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "nvim-tree/nvim-web-devicons",
        enabled = false,
        lazy = false,
        commit = "cff25ce621e6d15fae0b0bfe38c00be50ce38468",
    },
    pluginconf.devicons or {}
)
