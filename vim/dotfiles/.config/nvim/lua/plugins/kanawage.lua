local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    'force',
    {
        "rebelot/kanagawa.nvim",
        enabled = false,
        lazy = false,
        commit = "7735b2147ee6d223e43287044caa4fb070bdfa3d",
        config = function ()
            vim.cmd("colorscheme kanagawa")
        end
    },
    pluginconf.kanagawa or {}
)
