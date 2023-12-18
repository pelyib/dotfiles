return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            "nvim-telescope/telescope-live-grep-args.nvim" ,
            version = "^1.0.0",
        }
    },
    config = function ()
        local telescope = require("telescope")
        telescope.setup({
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

        telescope.load_extension("live_grep_args")
        vim.keymap.set("n", "fg", function () require('telescope').extensions.live_grep_args.live_grep_args() end )
    end
}
