local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        tag = "0.7.0",
    },
    pluginconf.dap or {}
)
