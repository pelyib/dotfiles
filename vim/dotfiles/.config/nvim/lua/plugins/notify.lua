return {
    "rcarriga/nvim-notify",
    tag = "v3.13.2",
    config = function ()
        vim.notify = require("notify")
        vim.notify.setup({background_colour = "#000000",})
    end
}
