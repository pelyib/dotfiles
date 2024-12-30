local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        enabled = false,
        tag = "v1.2.0",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },
    pluginconf.barbecue or {}
)
