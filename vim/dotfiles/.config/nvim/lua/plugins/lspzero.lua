local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'VonHeikemen/lsp-zero.nvim',
        enabled = false,
        lazy = false,
        branch = 'v3.x',
        dependencies = {
            {
                'neovim/nvim-lspconfig',
                commit = "9099871a7c7e1c16122e00d70208a2cd02078d80",
            },
            {
                'williamboman/mason.nvim',
                tag = 'v1.10.0',
                lazy = false,
                config = function()
                    require("mason").setup({})
                end,
            },
            {
                'williamboman/mason-lspconfig.nvim',
                tag = 'v1.29.0',
                config = function()
                    require("mason-lspconfig").setup({
                        ensure_installed = {
                            "lua_ls",
                            "bashls",
                            "cmake",
                            "dockerls",
                            "docker_compose_language_service",
                            "dotls",
                            "html",
                            "tsserver",
                            "lua_ls",
                            "autotools_ls",
                            "spectral",
                            "intelephense",
                            "sqlls",
                            "vimls"
                        },
                        automatic_installation = true,
                        handlers = {
                            function(server_name)
                                require('lspconfig')[server_name].setup({})
                            end,
                        }
                    })
                end,
            },
            {
                'hrsh7th/nvim-cmp',
                commit = '538e37ba87284942c1d76ed38dd497e54e65b891',
                dependencies = {
                    {
                        'hrsh7th/cmp-buffer',
                        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
                    },
                    {
                        'hrsh7th/cmp-nvim-lsp',
                        commit = "5af77f54de1b16c34b23cba810150689a3a90312",
                    },
                    {
                        'L3MON4D3/LuaSnip',
                        tag = 'v2.1.1',
                    }
                },
                config = function ()
                    local cmp = require("cmp")
                    cmp.setup({
                        sources = cmp.config.sources({
                            { name = 'nvim_lsp' }
                        }, {
                            { name = 'buffer' }
                        })
                    })
                end
            },
        }
    },
    pelyib.config.lspzero
)
