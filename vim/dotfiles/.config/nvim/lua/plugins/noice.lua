local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "folke/noice.nvim",
        enabled = false,
        tag = "v4.5.0",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function ()
            require("noice").setup({})
        end
    },
    pluginconf.noice or {}
)
