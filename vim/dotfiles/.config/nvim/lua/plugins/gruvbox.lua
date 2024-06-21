local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "morhetz/gruvbox",
        enabled = false,
        lazy = false,
        tag = "v2.0.0",
        config = function()
            vim.opt.termguicolors = true
        end
    },
    pelyib.config.gruvbox
)
