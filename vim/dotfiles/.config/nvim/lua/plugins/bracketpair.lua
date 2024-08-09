local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'fedepujol/bracketpair.nvim',
        enabled =  false,
        commit = "805b233f4fc1a36706e6fbc7259a244777677a53",
        config = function ()
        end
    },
    pelyib.bracketpair or {}
)
