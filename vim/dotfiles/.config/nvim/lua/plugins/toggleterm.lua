local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        'akinsho/toggleterm.nvim',
        enabled = false,
        version = "v2.5.0",
        config = function ()
            require('toggleterm').setup({
                direction = 'float',
                --open_mapping = [[<F7>]],
                open_mapping = [[<leader>t]],
                auto_scroll = false
            })
        end
    },
    pluginconf.toggleterm or {}
)
