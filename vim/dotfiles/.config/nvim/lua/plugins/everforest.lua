local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "sainnhe/everforest",
        enabled = false,
        lazy = false,
        tag = "v1.0.0",
        config = function()
            vim.g.everforest_transparent_background = 2
        end
    },
    pelyib.config.everforest
)
