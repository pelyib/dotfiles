local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "morhetz/gruvbox",
        enabled = false,
        lazy = false,
        tag = "v2.0.0",
        config = function()
            vim.opt.termguicolors = true
            vim.cmd("colorscheme gruvbox")
        end
    },
    pluginconf.gruvbox or {}
)
