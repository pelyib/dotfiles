local M = {}

M.plugins = {
    {
        "folke/tokyonight.nvim",
    },
    {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_transparent_background = 2
        end
    },
    {
        "morhetz/gruvbox",
        config = function()
            vim.opt.termguicolors = true
        end
    },
    'nvim-tree/nvim-web-devicons',
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function ()
            -- disable netrw at the very start of your init.lua (strongly advised)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true
            require("neo-tree").setup({
                window = {
                    position = "float"
                },
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        never_show = {
                            ".DS_Store",
                            "thumbs.db",
                            ".git"
                        }
                    }
                }
            })
            vim.keymap.set('n', 'fb', ':NeoTreeFloatToggle<CR>')
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function ()
            vim.cmd([[syntax off]])
            require("nvim-treesitter.configs").setup({
                ensure_installed = {"bash", "cmake", "css", "dockerfile", "dot", "graphql", "html", "lua", "make", "python", "javascript", "sql", "vim", "yaml", "regex", "go", "php", "markdown", "json"},
                highlight={
                    enable=true,
                    additional_vim_regex_highlighting=true,
                }
            })
        end
    },
    {
        'stevearc/aerial.nvim',
        config = function ()
            require('aerial').setup({
                close_automatic_events = {'unfocus'},
                layout={
                    default_direction = 'float'
                },
                float={
                    relative='win'
                }
            })
            vim.keymap.set('n', 'ar', ':AerialToggle<CR>')
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim',build = function() pcall(vim.cmd, 'MasonUpdate') end },
            {'williamboman/mason-lspconfig.nvim'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'}
        }
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function ()
            require("telescope").setup({
                defaults = {
                    path_display = {
                        "shorten",
                        shorten = {
                            len = 3,
                            exclude = {2, -1, -2}
                        }
                    },
                    layout_strategy = "vertical",
                    layout_config = {
                        horizontal = {
                            -- prompt_position = "top"
                        }
                    },
                    preview = {
                        treesitter = true,
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        --theme = 'dropdown'
                    },
                    live_grep = {
                        hidden = true,
                        show_line = false,
                        --theme = 'dropdown'
                    },
                    lsp_references = {
                        --theme = 'dropdown'
                    },
                }
            })
        end
    },
    {
        'akinsho/toggleterm.nvim',
        version = "v2.5.0",
        config = function ()
            require('toggleterm').setup({
                direction = 'float',
                --open_mapping = [[<F7>]],
                open_mapping = [[<leader>t]],
                auto_scroll = false
            })
        end
    },
    {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    },
    {
        'Exafunction/codeium.vim',
        enable = vim.g.pelyib_codeium_enabled,
        cond = false
    },
    {
        'phpactor/phpactor',
        config = function ()
            --[[
            TODO: add build script to run composer install in the installed plugin directory [botond.pelyi]
            cd into vim.fn.stdpath("data") .. '/lazy/phpactor'
            then run the composer install --no-dev --ignore-plaform-reqs
            --]]
            function PhpactorCreateNewObj()
                vim.api.nvim_call_function(
                'phpactor#rpc',
                { 'class_new', { current_path = vim.api.nvim_call_function('phpactor#_path', {}), variant = "default" } }
                )
            end

            function PhpactorImplementContract()
                vim.api.nvim_call_function(
                'phpactor#rpc',
                {
                    'transform',
                    {
                        transform = 'implement_contracts',
                        source = vim.api.nvim_call_function('phpactor#_source', {}),
                        path = vim.api.nvim_call_function('phpactor#_path', {})
                    }
                }
                )
            end

            vim.keymap.set('n', '<leader>pn', '<cmd>lua PhpactorCreateNewObj()<cr>')
            vim.keymap.set('n', '<leader>pi', '<cmd>lua PhpactorImplementContract()<cr>')
        end
    },
    {
        'stephpy/vim-php-cs-fixer',
        config = function ()
            function PhpCsFixerFixAll()
                vim.api.nvim_call_function('PhpCsFixerFixFile', {})
            end
            vim.keymap.set('n', 'csf', '<cmd>lua PhpCsFixerFixAll()<cr>')
            vim.g.php_cs_fixer_allow_risky = 'yes'
        end
    },
    {
        "jiangmiao/auto-pairs"
    },
    {
        'f-person/git-blame.nvim',
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        config = function ()
            vim.o.foldcolumn = '1'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local language_servers = require("lspconfig").util.available_servers()
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                })
            end

            require('ufo').setup()
        end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        'AckslD/nvim-neoclip.lua',
        dependencies = {
            {'kkharji/sqlite.lua', module = 'sqlite'},
        },
        config = function()
            require('neoclip').setup({enable_persistent_history = true, continuous_sync = true })
            require('telescope').load_extension('neoclip')
        end,
    },
    {
        "folke/neodev.nvim",
        opts = {}
    }
}

M.setup = function ()
    require("lazy").setup(M.plugins, {})
end

return M
