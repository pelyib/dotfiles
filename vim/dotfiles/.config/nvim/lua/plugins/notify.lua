return {
    "rcarriga/nvim-notify",
    enabled = true,
    tag = "v3.13.5",
    config = function ()
        vim.notify = require("notify")
        vim.notify.setup({background_colour = "#000000",})
    end
}
