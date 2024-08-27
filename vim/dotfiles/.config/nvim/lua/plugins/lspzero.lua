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
                tag = 'v0.1.8'
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
                            "spectral",
                            "sqlls",
                            "tsserver",
                            "vimls",
                        },
                        automatic_installation = true,
                        handlers = {
                            tsserver = function ()
                                require('lspconfig').tsserver.setup({
                                    filetypes = {
                                        "javascript",
                                        "javascriptreact",
                                        "javascript.jsx",
                                        "typescript",
                                        "typescriptreact",
                                        "typescript.tsx",
                                    },
                                })
                            end,

                            eslint = function()
                                require('lspconfig').eslint.setup({
                                    filetypes = {
                                        "javascript",
                                        "javascriptreact",
                                        "javascript.jsx",
                                        "typescript",
                                        "typescriptreact",
                                        "typescript.tsx",
                                    },
                                    on_attach = function(client, bufnr)
                                        vim.api.nvim_create_autocmd("BufWritePre", {
                                            buffer = bufnr,
                                            command = "EslintFixAll",
                                        })
                                    end
                                })
                            end,

                            html = function ()
                                local capabilities = vim.lsp.protocol.make_client_capabilities()
                                capabilities.textDocument.completion.completionItem.snippetSupport = true

                                require('lspconfig').html.setup {
                                    capabilities = capabilities,
                                }
                            end,

                            function(server_name)
                                require('lspconfig')[server_name].setup({})
                            end
                        }
                    })
                end,
            },
            {
                'hrsh7th/nvim-cmp',
                commit = 'd818fd0624205b34e14888358037fb6f5dc51234',
                dependencies = {
                    {
                        'hrsh7th/cmp-buffer',
                        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
                    },
                    {
                        'hrsh7th/cmp-nvim-lsp',
                        commit = "39e2eda76828d88b773cc27a3f61d2ad782c922d",
                        lazy = false,
                    },
                    {
                        'hrsh7th/cmp-path',
                        commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
                    },
                    {
                        'L3MON4D3/LuaSnip',
                        tag = 'v2.1.1',
                    }
                },
                config = function ()
                    local cmp = require("cmp")
                    cmp.setup({
                        sources = cmp.config.sources(
                            {
                                { name = 'nvim_lsp', group_index = 0, max_item_count = 5 }
                            },
                            {
                                { name = 'codeium', group_index = 1000, max_item_count = 5 }
                            },
                            {
                                { name = 'path', group_index = 2000, max_item_count = 5 }
                            },
                            {
                                { name = "lazydev", group_index = 3000, max_item_count = 5 }
                            },
                            {
                                { name = 'buffer', group_index = 4000, max_item_count = 2 }
                            }
                        )
                    })
                end
            },
        }
    },
    pelyib.config.lspzero
)
