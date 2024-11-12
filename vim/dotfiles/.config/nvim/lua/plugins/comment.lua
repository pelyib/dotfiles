local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        'numToStr/Comment.nvim',
        enabled = false,
        tag = "v0.8.0",
        config = function()
            require('Comment').setup()
        end
    },
    pluginconf.comment
)
