local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        "nvim-neotest/neotest",
        tag = "v5.6.1",
        enabled = false,
        lazy = true,
        dependencies = {
            {
                "nvim-neotest/nvim-nio",
                tag = "v1.10.0",
            },
            {
                "antoinemadec/FixCursorHold.nvim",
                commit = "1900f89dc17c603eec29960f57c00bd9ae696495"
            },
            {
                "nvim-neotest/neotest-plenary",
                commit = "3523adcf9ffaad1911960c5813b0136c1b63a2ec"
            },
            {
                "nvim-neotest/neotest-jest",
                commit = "514fd4eae7da15fd409133086bb8e029b65ac43f"
            },
            {
                "olimorris/neotest-phpunit",
                commit = "baae8dfa0a3aaacd9f0bb6845d6348f5bcdc48bb"
            }
        },
        config = function ()
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary"),
                    require("neotest-phpunit")(pelyib.config.neotest_phpunit.setup or {}),
                },
            })
        end
    },
    pelyib.config.neotest or {}
)
