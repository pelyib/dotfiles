local hostConf = require('pelyib.pluginconf-host')
local projectConf = require('pelyib.pluginconf-project')

local M = {
    config = {
        patched = {},
        origin = {
            aerial = {
                enabled = false,
            },
            alpha = {
                enabled = false,
            },
            autopairs = {
                enabled = false,
            },
            bracketpair = {
                enabled = false,
            },
            codeium = {
                enabled = false,
            },
            comment = {
                enabled = false,
            },
            copilot = {
                enabled = false,
            },
            dapui = {
                enabled = false,
            },
            dap = {
                enabled = false,
            },
            devicons = {
                enabled = false,
            },
            dressing = {
                enabled = false,
            },
            gitblame = {
                enabled = false,
            },
            kanagawa = {
                enabled = false,
            },
            gruvbox = {
                enabled = false,
            },
            lazydev = {
                enabled = false,
            },
            lspzero = {
                enabled = false,
            },
            neoclip = {
                enabled = false,
            },
            neodev = {
                enabled = false,
            },
            neotree = {
                enabled = false,
            },
            neotest = {
                enabled = false,
            },
            neotest_jest = {
                enabled = false,
            },
            neotest_phpunit = {
                enabled = false,
                setup = {
                    phpunit_cmd = function()
                        return "./vim/vendor/neotest/phpunit"
                    end,
                    env = {
                        COMMAND = "./vendor/bin/phpunit",
                        HOST_PROJECT_ROOT = "/host/filesystem/project/root",
                        CONTAINER_PROJECT_ROOT = "/container/filesystem/project/root",
                        JUNIT_LOG_FILE = "/tests/_output/junit.xml",
                    },
                }
            },
            neotest_pest = {
                enabled = false,
                setup = {
                    sail_enabled = function () return false end,
                    --pest_cmd = "./dev run ./vendor/bin/pest",
                    pest_cmd = "/Users/botond.pelyi/Projects/dotfiles/vim/vendor/neotest/pest",
                }
            },
            noice = {
                enabled = false,
            },
            notify = {
                enabled = false,
            },
            phpactor = {
                enabled = false,
            },
            phpactornvim = {
                enabled = false,
            },
            phpcsfixer = {
                enabled = false,
            },
            telescope = {
                enabled = false,
            },
            toggleterm = {
                enabled = false,
            },
            treesitter = {
                enabled = false,
            },
            ufo = {
                enabled = false,
            },

        }},
    host = {
        origin = {}
    },
    project = {
        origin = {}
    }
}

M.setup = function ()
    M.config.patched = vim.tbl_deep_extend("force", M.config.origin, hostConf.config, projectConf.config)
end

return M
