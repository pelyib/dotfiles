local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    'force',
    {
        "rebelot/kanagawa.nvim",
        commit = "7735b2147ee6d223e43287044caa4fb070bdfa3d",
        enabled = false,
        config = function ()
            vim.cmd("colorscheme kanagawa")
        end
    },
    pelyib.config.kanagawa or {}
)
