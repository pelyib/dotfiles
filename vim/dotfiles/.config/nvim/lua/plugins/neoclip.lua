local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "AckslD/nvim-neoclip.lua",
        enabled = false,
        commit = "4e406ae",
        dependencies = {
            {'kkharji/sqlite.lua', module = 'sqlite'},
        },
        config = function()
            require('neoclip').setup({enable_persistent_history = true, continuous_sync = true })
            require('telescope').load_extension('neoclip')
        end,
    },
    pelyib.config.neoclip
)
