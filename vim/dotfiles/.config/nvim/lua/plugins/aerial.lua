local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "stevearc/aerial.nvim",
        commit = "8876456",
        enabled = false,
        config = function ()
            require('aerial').setup({
                close_automatic_events = {'unfocus'},
                layout={
                    default_direction = 'float'
                },
                float={
                    relative='win'
                }
            })
        end
    },
    pelyib.config.aerial or {}
)
