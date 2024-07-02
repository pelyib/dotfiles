local pelyib = vim.g.pelyib.pluginconfig

--[[
https://github.com/folke/neodev.nvim/releases/tag/v3.0.0
It is deprecated, check the repo for more details
TODO remove this plugin
--]]
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
