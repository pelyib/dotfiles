local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "SmiteshP/nvim-navbuddy",
        commit = "f22bac988f2dd073601d75ba39ea5636ab6e38cb",
        enabled = false,
        dependencies = {
            {
                "SmiteshP/nvim-navic",
                commit = "8649f694d3e76ee10c19255dece6411c29206a54"
            },
            "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
    },
    pluginconf.navbuddy or {}
)
