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
                    local lsp_zero = require('lsp-zero')
                    lsp_zero.extend_lspconfig()

                    lsp_zero.on_attach(function(client, bufnr)
                        lsp_zero.default_keymaps({buffer = bufnr})
                    end)

                    require("mason-lspconfig").setup({
                        ensure_installed = {
                            "autotools_ls",
                            "bashls",
                            "cmake",
                            "docker_compose_language_service",
                            "dockerls",
                            "dotls",
                            "eslint",
                            "html",
                            "intelephense",
                            "lua_ls",
                            "lua_ls",
                            "spectral",
                            "sqlls",
                            "tsserver",
                            "vimls",
                        },
                        automatic_installation = true,
                        handlers = {
                            function(server_name)
                                require('lspconfig')[server_name].setup({})
                            end,

                            eslint = function()
                                require('lspconfig').eslint.setup({
                                    on_attach = function(client, bufnr)
                                        vim.api.nvim_create_autocmd("BufWritePre", {
                                            buffer = bufnr,
                                            command = "EslintFixAll",
                                        })
                                    end
                                })
                            end
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
