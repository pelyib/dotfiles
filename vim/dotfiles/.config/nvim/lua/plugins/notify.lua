local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "rcarriga/nvim-notify",
        enabled = false,
        tag = "v3.13.5",
        config = function ()
            vim.notify = require("notify")
            vim.notify.setup({background_colour = "#000000",})
        end
    },
    pelyib.config.notify
)
