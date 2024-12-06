local pluginconf = require('pelyib.pluginconf').config.patched

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
            },
            {
                'V13Axel/neotest-pest',
                --tag = 'v1.0'
                commit = "b665a4881c706eea476fcaf79a21996e9b65514d"
            }
        },
        config = function ()

            local adapters = {
                require("neotest-plenary"),
            }
            if (pluginconf.neotest_pest.enabled) then
                table.insert(adapters, require("neotest-pest")(pluginconf.neotest_pest.setup or {}))
            end
            if (pluginconf.neotest_jest.enabled) then
                table.insert(adapters, require("neotest-jest")({
                    jestCommand = "npm run test --detectOpenHandles",
                    --jestCommand = "/Users/botond.pelyi/Projects/dotfiles/vim/vendor/neotest/jest --detectOpenHandles",
                    jestConfigFile = "/Users/botond.pelyi/Projects/portal/jest.config.ts"
                }))
            end
            if (pluginconf.neotest_phpunit.enabled) then
                table.insert(adapters, require("neotest-phpunit")(pluginconf.neotest_phpunit.setup or {}))
            end

            require("neotest").setup({
                log_level = vim.log.levels.DEBUG,
                adapters = adapters,
                discovery = {
                    enabled = false,
                },
            })
        end
    },
    pluginconf.neotest or {}
)
