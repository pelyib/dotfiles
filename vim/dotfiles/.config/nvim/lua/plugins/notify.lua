return {
    "rcarriga/nvim-notify",
    tag = "v3.13.2",
    config = function ()
        vim.notify = require("notify")
    end
}
