local pluginconf_ok, pluginconf = pcall(require, 'pelyib.pluginconf')
if not pluginconf_ok then
    pluginconf = { config = { patched = {} } }
else
    pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend(
    "force",
    {
        "nvim-neotest/neotest",
        tag = "v5.6.1",
        enabled = false,
        lazy = true,
        cmd = { "Neotest" },
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
            },
            {
                "fredrikaverpil/neotest-golang",
                tag = "v1.6.2",
            }
        },
        config = function ()

            local adapters = {}
            local plenary_ok, plenary = pcall(require, "neotest-plenary")
            if plenary_ok then
                table.insert(adapters, plenary)
            end
            if (pluginconf.neotest_pest and pluginconf.neotest_pest.enabled) then
                local pest_ok, pest = pcall(require, "neotest-pest")
                if pest_ok then
                    table.insert(adapters, pest(pluginconf.neotest_pest.setup or {}))
                end
            end
            if (pluginconf.neotest_jest and pluginconf.neotest_jest.enabled) then
                local jest_ok, jest = pcall(require, "neotest-jest")
                if jest_ok then
                    table.insert(adapters, jest({
                        jestCommand = "npm run test --detectOpenHandles",
                        --jestCommand = "/Users/botond.pelyi/Projects/dotfiles/vim/vendor/neotest/jest --detectOpenHandles",
                        jestConfigFile = "/Users/botond.pelyi/Projects/portal/jest.config.ts"
                    }))
                end
            end
            if (pluginconf.neotest_phpunit and pluginconf.neotest_phpunit.enabled) then
                local phpunit_ok, phpunit = pcall(require, "neotest-phpunit")
                if phpunit_ok then
                    table.insert(adapters, phpunit(pluginconf.neotest_phpunit.setup or {}))
                end
            end
            if (pluginconf.neotest_golang and pluginconf.neotest_golang.enabled) then
                local golang_ok, golang = pcall(require, "neotest-golang")
                if golang_ok then
                    table.insert(adapters, golang())
                end
            end

            local neotest_ok, neotest = pcall(require, "neotest")
            if neotest_ok then
                neotest.setup({
                    log_level = vim.log.levels.DEBUG,
                    adapters = adapters,
                    discovery = {
                        enabled = false,
                    },
                })
            end
        end
    },
    pluginconf.neotest or {}
)
