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
                -- setup = {
                --     phpunit_cmd = function()
                --         return "/absolute/path/of/dotfiles/vim/vendor/neotest/phpic"
                --     end,
                -- }
            },
            neotest_pest = {
                enabled = false,
                -- setup = {
                --     sail_enabled = function () return false end,
                --     pest_cmd = "/absolute/path/of/dotfiles/vim/vendor/neotest/phpic",
                -- }
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
