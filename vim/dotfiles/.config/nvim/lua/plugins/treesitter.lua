local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'nvim-treesitter/nvim-treesitter',
        enabled = false,
        lazy = false,
        tag = 'v0.9.2',
        build = ":TSUpdate",
        config = function ()
            vim.cmd([[syntax off]])
            require("nvim-treesitter.configs").setup({
                ensure_installed = {"bash", "cmake", "css", "dockerfile", "dot", "graphql", "html", "lua", "make", "python", "javascript", "sql", "vim", "yaml", "regex", "go", "php", "markdown", "json" },
                highlight={
                    enable = true,
                    additional_vim_regex_highlighting=true,
                }
            })
        end
    },
    pelyib.config.treesitter
)
