local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        'pelyib/formatter',
        enabled = false,
        dir = vim.fn.stdpath("config") .. "/lua/pelyib",
        config = function()
            require('pelyib.formatter').setup()
        end,
        dependencies = {
            'rcarriga/nvim-notify',
        },
    },
    pluginconf.formatter or {}
)
