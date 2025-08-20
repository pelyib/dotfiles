local pluginconf_ok, pluginconf = pcall(require, 'pelyib.pluginconf')
if not pluginconf_ok then
    pluginconf = { config = { patched = {} } }
else
    pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend(
    "force",
    {
        'VonHeikemen/lsp-zero.nvim',
        enabled = false,
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        branch = 'v3.x',
        dependencies = {
            {
                'neovim/nvim-lspconfig',
                tag = 'v0.1.8',
                lazy = true,
            },
            {
                'williamboman/mason.nvim',
                tag = 'v1.10.0',
                lazy = true,
                cmd = "Mason",
                config = function()
                    local mason_ok, mason = pcall(require, "mason")
                    if mason_ok then
                        mason.setup({})
                    end
                end,
            },
            {
                'williamboman/mason-lspconfig.nvim',
                tag = 'v1.29.0',
                lazy = true,
                config = function()
                    local lsp_zero_ok, lsp_zero = pcall(require, 'lsp-zero')
                    if not lsp_zero_ok then
                        return
                    end
                    lsp_zero.extend_lspconfig()

                    lsp_zero.on_attach(function(client, bufnr)
                        lsp_zero.default_keymaps({buffer = bufnr})
                    end)

                    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
                    if not mason_lspconfig_ok then
                        return
                    end
                    mason_lspconfig.setup({
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
                            "sqlls",
                            "tsserver",
                            "vimls",
                            "yamlls",
                        },
                        automatic_installation = true,
                        handlers = {
                            tsserver = function ()
                                local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
                                if not lspconfig_ok then
                                    return
                                end
                                lspconfig.tsserver.setup({
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
                                local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
                                if not lspconfig_ok then
                                    return
                                end
                                lspconfig.eslint.setup({
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
                                        vim.notify("EslintFixAll will run on save", "info")
                                    end
                                })
                            end,

                            html = function ()
                                local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
                                if not lspconfig_ok then
                                    return
                                end
                                local capabilities = vim.lsp.protocol.make_client_capabilities()
                                capabilities.textDocument.completion.completionItem.snippetSupport = true

                                lspconfig.html.setup {
                                    capabilities = capabilities,
                                }
                            end,

                            function(server_name)
                                local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
                                if lspconfig_ok then
                                    lspconfig[server_name].setup({})
                                end
                            end
                        }
                    })
                end,
            },
            {
                'hrsh7th/nvim-cmp',
                commit = 'd818fd0624205b34e14888358037fb6f5dc51234',
                lazy = true,
                event = "InsertEnter",
                dependencies = {
                    {
                        'hrsh7th/cmp-buffer',
                        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
                        lazy = true,
                    },
                    {
                        'hrsh7th/cmp-nvim-lsp',
                        commit = "39e2eda76828d88b773cc27a3f61d2ad782c922d",
                        lazy = true,
                    },
                    {
                        'hrsh7th/cmp-path',
                        commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
                        lazy = true,
                    },
                    {
                        'L3MON4D3/LuaSnip',
                        tag = 'v2.1.1',
                        lazy = true,
                    }
                },
                config = function ()
                    local cmp_ok, cmp = pcall(require, "cmp")
                    if not cmp_ok then
                        return
                    end
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
    pluginconf.lspzero or {}
)
